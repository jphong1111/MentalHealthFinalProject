
import os
import re
import sys
from pathlib import Path

DELEGATE_KEYWORDS = [
    "tableView", "collectionView", "pickerView", "textView",
    "textField", "scrollView", "numberOfRows", "didSelect",
    "titleForRow", "cellForRow", "didEnd", "shouldSelect", "willDisplay",
    "gestureRecognizer", "pageViewController"
]

def extract_class_level_vars(content):
    lines = [line for line in content.splitlines() if not line.strip().startswith("//")]
    class_body = "\n".join(lines).split("func")[0]
    return re.findall(r'(?<!static\s)(?:private|internal)?\s*var\s+(\w+)\s*:\s*([^\n=]+)', class_body)

def extract_protocol_method_names(content):
    protocol_blocks = re.findall(r'protocol\s+\w+\s*:\s*[^\{]*\{([^}]*)\}', content, re.DOTALL)
    method_names = set()
    for block in protocol_blocks:
        matches = re.findall(r'func\s+(\w+)\s*\(', block)
        method_names.update(matches)
    return method_names

def extract_functions(content):
    lines = content.splitlines()
    functions = []
    for line in lines:
        if line.strip().startswith("//"):
            continue
        match = re.match(r'(?:@\w+\s+)*func\s+(\w+)\s*\(([^)]*)\)\s*(?:->\s*([^\{\s]+))?', line.strip())
        if match:
            functions.append(match.groups())
    return functions

def is_objc_annotated(content, func_name):
    pattern = r'@objc\s+(?:private\s+)?func\s+' + re.escape(func_name)
    return re.search(pattern, content) is not None

def generate_test_hooks_for_file(filepath: str):
    with open(filepath, "r") as f:
        content = f.read()

    class_match = re.search(r'final\s+class\s+(\w+)', content)
    if not class_match:
        return None

    class_name = class_match.group(1)
    protocol_methods = extract_protocol_method_names(content)
    var_matches = extract_class_level_vars(content)
    func_matches = extract_functions(content)

    functions = []
    for func_name, params, return_type in func_matches:
        if func_name in ["init", "deinit"] or func_name.startswith("view") or func_name.startswith("navigate"):
            continue
        if func_name in protocol_methods:
            continue
        if any(keyword in func_name for keyword in DELEGATE_KEYWORDS):
            continue
        if is_objc_annotated(content, func_name):
            continue
        functions.append((func_name, params, return_type))

    lines = [
        "#if DEBUG",
        f"extension {class_name} {{",
        "    var testHooks: TestHooks { .init(target: self) }",
        "",
        "    struct TestHooks {",
        f"        var target: {class_name}",
        ""
    ]

    added_vars = set()
    static_pattern = re.compile(r'static\s+var\s+\w+')
    for var_name, var_type in var_matches:
        if "delegate" in var_name.lower():
            continue
        if var_name in added_vars:
            continue
        pattern = re.compile(rf'static\s+var\s+{re.escape(var_name)}\b')
        if pattern.search(content):
            continue
        cleaned_type = var_type.strip()
        lines.append(f"        var {var_name}: {cleaned_type} {{ target.{var_name} }}")
        lines.append("")
        added_vars.add(var_name)

    for i, (func_name, param_str, return_type) in enumerate(functions):
        param_str = param_str.strip()
        call_args = []
        func_signature_params = []
        if param_str:
            param_parts = [p.strip() for p in param_str.split(",") if p.strip()]
            for part in param_parts:
                match = re.match(r"(_)?\s*(\w+)\s*:\s*(.+)", part)
                if match:
                    underscore = match.group(1)
                    name = match.group(2)
                    type_ = match.group(3)
                    if underscore:
                        func_signature_params.append(f"_ {name}: {type_}")
                        call_args.append(f"{name}")
                    else:
                        func_signature_params.append(f"{name}: {type_}")
                        call_args.append(f"{name}: {name}")
                else:
                    name = part.split(":")[0].strip()
                    func_signature_params.append(part)
                    call_args.append(f"{name}: {name}")

            signature = ", ".join(func_signature_params)
            call = ", ".join(call_args)

            if return_type:
                lines.append(f"        func {func_name}({signature}) -> {return_type} {{")
                lines.append(f"            target.{func_name}({call})")
                lines.append("        }")
            else:
                lines.append(f"        func {func_name}({signature}) {{")
                lines.append(f"            target.{func_name}({call})")
                lines.append("        }")
        else:
            if return_type:
                lines.append(f"        func {func_name}() -> {return_type} {{ target.{func_name}() }}")
            else:
                lines.append(f"        func {func_name}() {{ target.{func_name}() }}")

        if i != len(functions) - 1:
            lines.append("")

    lines.extend([
        "    }",
        "}",
        "#endif"
    ])

    final_output = "\n".join(lines)
    final_output = re.sub(r'\{\s*\{', '{', final_output)

    if "#if DEBUG" not in content and f"extension {class_name} " not in content:
        new_content = content.rstrip() + "\n\n" + final_output
        with open(filepath, "w") as f:
            f.write(new_content)
        return filepath
    return None

def process_files(filepaths):
    modified = []
    for path in filepaths:
        filepath = Path(path)
        if filepath.suffix != ".swift" or not filepath.exists():
            continue
        result = generate_test_hooks_for_file(str(filepath))
        if result:
            modified.append(result)
    return modified

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("⚠️ No Swift files provided.")
        sys.exit(0)

    modified = process_files(sys.argv[1:])
    if modified:
        print(f"✅ testHooks added to: {', '.join(modified)}")
    else:
        print("✨ No updates needed.")

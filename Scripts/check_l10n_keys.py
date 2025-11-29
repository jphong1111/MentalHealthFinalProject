#!/usr/bin/env python3
import argparse, json, subprocess, sys, re
from pathlib import Path

def parse_args():
    p = argparse.ArgumentParser(description="Check parity between EN and KO Localizable.strings keys.")
    p.add_argument("--en", help="Path to EN Localizable.strings", default=None)
    p.add_argument("--ko", help="Path to KO Localizable.strings", default=None)
    p.add_argument("--limit", type=int, default=50, help="Max number of keys to print per section (0 = unlimited)")
    return p.parse_args()

def auto_find(glob_pattern: str):
    root = Path(__file__).resolve().parents[1]
    matches = sorted(root.glob(glob_pattern))
    return matches[0] if matches else None

def load_strings_via_plutil(path: Path) -> dict:
    try:
        out = subprocess.run(
            ["plutil", "-convert", "json", "-o", "-", str(path)],
            capture_output=True, text=True, check=True
        )
        return json.loads(out.stdout)
    except subprocess.CalledProcessError as e:
        print(f"❌ plutil failed on {path}:\n{e.stderr}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"❌ JSON parse failed on {path}: {e}")
        sys.exit(1)

def print_list(title: str, items, limit: int, value_map=None):
    n = len(items)
    if n == 0:
        return
    print(f"{title} [{n}]")
    show = items if limit == 0 else items[:limit]
    for k in show:
        if value_map and k in value_map:
            v = value_map[k]
            # 값은 길면 살짝 잘라서 표시
            vs = (v[:60] + "…") if len(v) > 60 else v
            print(f'  - "{k}"    value: "{vs}"')
        else:
            print(f'  - "{k}"')
    if limit and n > limit:
        print(f"  … and {n - limit} more")

def warn_suspicious_keys(locale: str, keys):
    # 공백/쉼표/느낌표 등 문장처럼 보이는 키 경고 (필요시 규칙 조정)
    sus = [k for k in keys if re.search(r"[^\w\.\-]", k)]  # \w = [A-Za-z0-9_]
    if sus:
        print(f"⚠️  Suspicious {locale} keys (contain spaces or punctuation): [{len(sus)}]")
        for k in sus[:20]:
            print(f'  - "{k}"')
        if len(sus) > 20:
            print(f"  … and {len(sus) - 20} more")

def main():
    args = parse_args()

    en_path = Path(args.en) if args.en else auto_find("**/en.lproj/Localizable.strings")
    ko_path = Path(args.ko) if args.ko else auto_find("**/ko.lproj/Localizable.strings")

    if not en_path or not ko_path:
        print("❌ Cannot find Localizable.strings for both EN and KO.")
        print(f"   EN: {en_path}")
        print(f"   KO: {ko_path}")
        sys.exit(1)

    en_map = load_strings_via_plutil(en_path)
    ko_map = load_strings_via_plutil(ko_path)

    en_keys = sorted(en_map.keys())
    ko_keys = sorted(ko_map.keys())

    print("📄 Using files:")
    print(f"   EN: {en_path}  (keys: {len(en_keys)})")
    print(f"   KO: {ko_path}  (keys: {len(ko_keys)})")

    missing_in_ko = sorted(set(en_keys) - set(ko_keys))  # EN에만 있음
    extra_in_ko   = sorted(set(ko_keys) - set(en_keys))  # KO에만 있음

    ok = True
    if missing_in_ko or extra_in_ko:
        ok = False
        print("❌ Localization key mismatch detected.")
        print_list(" - Missing in KO (present in EN only)", missing_in_ko, args.limit, value_map=en_map)
        print_list(" - Extra in KO (not in EN)",           extra_in_ko,   args.limit, value_map=ko_map)
    else:
        print("✅ Localization keys are in sync.")

    # 의심 키 경고(문장 같은 키 탐지)
    warn_suspicious_keys("EN", en_keys)
    warn_suspicious_keys("KO", ko_keys)

    sys.exit(0 if ok else 1)

if __name__ == "__main__":
    main()

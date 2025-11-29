//
//  UserDefaultsEditorViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG
import UIKit

final class UserDefaultsEditorViewController: UIViewController {
    enum ValueType: Int, CaseIterable {
        case string, bool, int, double, json

        var title: String {
            switch self {
            case .string: return "String"
            case .bool:   return "Bool"
            case .int:    return "Int"
            case .double: return "Double"
            case .json:   return "JSON (Array/Dict)"
            }
        }
    }

    private let key: String
    private var currentType: ValueType
    // UI
    private let typeControl = UISegmentedControl(items: ValueType.allCases.map { $0.title })
    private let textView = UITextView()
    private let boolSwitch = UISwitch()

    init(key: String, value: Any) {
        self.key = key
        self.currentType = UserDefaultsEditorViewController.inferType(from: value)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = key

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteKey)),
            UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction { _ in DebugPanelEnvironment.shared.onClose?() }
        )
        typeControl.selectedSegmentIndex = currentType.rawValue
        typeControl.addTarget(self, action: #selector(typeChanged), for: .valueChanged)

        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = true

        let stack = UIStackView(arrangedSubviews: [typeControl, boolSwitch, textView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textView.heightAnchor.constraint(equalToConstant: 220)
        ])

        // 현재 값 로드
        loadCurrentValue()
        updateVisibleInputs()
    }

    private func loadCurrentValue() {
        let dict = UserDefaults.standard.dictionaryRepresentation()
        let value = dict[key]

        switch currentType {
        case .bool:
            boolSwitch.isOn = (value as? Bool) ?? false
            textView.text = ""
        case .int:
            if let n = value as? NSNumber { textView.text = "\(n.intValue)" }
            else if let s = value as? String { textView.text = s }
            else { textView.text = "" }
        case .double:
            if let n = value as? NSNumber { textView.text = "\(n.doubleValue)" }
            else if let s = value as? String { textView.text = s }
            else { textView.text = "" }
        case .string:
            textView.text = value as? String ?? ""
        case .json:
            if let obj = value {
                if JSONSerialization.isValidJSONObject(obj) {
                    let data = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
                    textView.text = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                } else {
                    textView.text = String(describing: obj)
                }
            } else {
                textView.text = ""
            }
        }
    }

    @objc private func typeChanged() {
        currentType = ValueType(rawValue: typeControl.selectedSegmentIndex) ?? .string
        updateVisibleInputs()
    }

    private func updateVisibleInputs() {
        boolSwitch.isHidden = (currentType != .bool)
        textView.isHidden   = (currentType == .bool)

        switch currentType {
        case .int:
            textView.keyboardType = .numberPad
        case .double:
            textView.keyboardType = .numbersAndPunctuation
        default:
            textView.keyboardType = .default
        }
    }

    @objc private func save() {
        let ud = UserDefaults.standard

        switch currentType {
        case .bool:
            ud.set(boolSwitch.isOn, forKey: key)

        case .int:
            guard let i = Int(textView.text.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                return alert("Invalid Int", "정수 값을 입력하세요.")
            }
            ud.set(i, forKey: key)

        case .double:
            guard let d = Double(textView.text.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                return alert("Invalid Double", "숫자 값을 입력하세요.")
            }
            ud.set(d, forKey: key)

        case .string:
            ud.set(textView.text, forKey: key)

        case .json:
            let raw = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let data = raw.data(using: .utf8) else {
                return alert("Invalid JSON", "UTF-8 인코딩 실패")
            }
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                guard JSONSerialization.isValidJSONObject(obj) || obj is [Any] || obj is [String: Any] else {
                    return alert("Unsupported", "Array 또는 Dictionary 형태의 JSON만 지원합니다.")
                }
                ud.set(obj, forKey: key)
            } catch {
                return alert("JSON Parse Error", error.localizedDescription)
            }
        }

        navigationController?.popViewController(animated: true)
    }

    @objc private func deleteKey() {
        UserDefaults.standard.removeObject(forKey: key)
        navigationController?.popViewController(animated: true)
    }

    private func alert(_ title: String, _ msg: String) {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    private static func inferType(from v: Any) -> ValueType {
        switch v {
        case is Bool: return .bool
        case is Int, is Int8, is Int16, is Int32, is Int64,
             is UInt, is UInt8, is UInt16, is UInt32, is UInt64: return .int
        case is Float, is Double, is NSNumber: return .double
        case is [Any], is [String: Any]: return .json
        case is String: return .string
        default: return .string
        }
    }
}

#endif

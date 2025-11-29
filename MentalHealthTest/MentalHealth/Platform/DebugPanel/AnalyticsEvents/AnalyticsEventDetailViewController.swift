//
//  AnalyticsEventDetailViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/5/25.
//

#if DEBUG

import UIKit

final class AnalyticsEventDetailViewController: UIViewController {
    private let name: String
    private let params: [AnalyticsKey: Any]?
    init(name: String, params: [AnalyticsKey: Any]?) {
        self.name = name; self.params = params
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
        view.backgroundColor = .systemBackground

        let tv = UITextView()
        tv.isEditable = false
        tv.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        tv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tv)
        NSLayoutConstraint.activate([
            tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tv.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
        ])

        var dict: [String: Any] = ["event": name]
        if let params {
            dict["parameters"] = jsonNormalize(params)
        }
        tv.text = jsonString(from: dict)
    }

    private func jsonNormalize(_ value: Any) -> Any {
        switch value {
        case let v as String: return v
        case let v as NSNumber: return v
        case let v as Int: return v
        case let v as Double: return v
        case let v as Float: return v
        case let v as Bool: return v
        case let v as Date:
            let f = ISO8601DateFormatter()
            return f.string(from: v)
        case let v as URL: return v.absoluteString
        case let v as any AnalyticsString: return v.rawValue
        case let v as [Any]:
            return v.map { jsonNormalize($0) }
        case let v as [String: Any]:
            return v.reduce(into: [String: Any]()) { out, e in out[e.key] = jsonNormalize(e.value) }
        case let v as [AnalyticsKey: Any]:
            return v.reduce(into: [String: Any]()) { out, e in out[e.key.rawValue] = jsonNormalize(e.value) }
        default:
            return String(describing: value)
        }
    }

    private func jsonString(from object: Any) -> String {
        if let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]),
           let s = String(data: data, encoding: .utf8) {
            return s
        } else {
            return String(describing: object)
        }
    }
}

#endif

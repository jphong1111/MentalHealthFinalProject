//
//  AnalyticsEventsViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG

import UIKit

final class AnalyticsEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    private let table = UITableView(frame: .zero, style: .insetGrouped)
    private let search = UISearchController(searchResultsController: nil)
    private var filtered: [DebugAnalyticsRecord] = []

    private var autoScroll = true
    private var showOnlyEvents = true

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Please use copy button"
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close,
            primaryAction: UIAction { _ in DebugPanelEnvironment.shared.onClose?() })

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Copy JSON", style: .plain,
                            target: self, action: #selector(copyJSON)),
            UIBarButtonItem(title: "Share", style: .plain,
                            target: self, action: #selector(shareJSON))
        ]

        // 상단 툴바 스위치들
        let seg = UISegmentedControl(items: ["Events", "All"])
        seg.selectedSegmentIndex = showOnlyEvents ? 0 : 1
        seg.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.showOnlyEvents = (seg.selectedSegmentIndex == 0)
            self.applyFilter()
        }, for: .valueChanged)
        navigationItem.titleView = seg

        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        search.searchResultsUpdater = self
        navigationItem.searchController = search

        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .debugAnalyticsUpdated, object: nil)
        reload()
    }

    @objc private func reload() {
        applyFilter()
        if autoScroll, filtered.count > 0 {
            let last = IndexPath(row: filtered.count - 1, section: 0)
            table.scrollToRow(at: last, at: .bottom, animated: true)
        }
    }

    private func applyFilter() {
        let q = (search.searchBar.text ?? "").lowercased()
        let src = DebugAnalyticsStore.shared.records.filter { rec in
            if showOnlyEvents {
                if case .event = rec {} else { return false }
            }
            return true
        }
        filtered = src.filter { rec in
            switch rec {
            case let .event(name, params, _):
                return name.lowercased().contains(q) || (params?.description.lowercased().contains(q) ?? false)
            case let .userProperty(name, value, _):
                return name.lowercased().contains(q) || (value?.lowercased().contains(q) ?? false)
            case let .userId(id, _):
                return (id).lowercased().contains(q)
            case let .defaultParams(p, _):
                return (p?.description.lowercased().contains(q) ?? false)
            }
        }
        table.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) { applyFilter() }

    // MARK: table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filtered.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rec = filtered[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()

        switch rec {
        case let .event(name, params, ts):
            config.text = "event · \(name)"
            config.secondaryText = prettyParams(params) + "  ·  " + timeString(ts)
            cell.accessoryType = .disclosureIndicator

        case let .userProperty(name, value, ts):
            config.text = "userProperty · \(name)"
            config.secondaryText = "\(value ?? "nil")  ·  " + timeString(ts)
            cell.accessoryType = .none

        case let .userId(id, ts):
            config.text = "userId"
            config.secondaryText = "\(id)  ·  " + timeString(ts)
            cell.accessoryType = .none

        case let .defaultParams(p, ts):
            config.text = "defaultParams"
            config.secondaryText = prettyParams(p) + "  ·  " + timeString(ts)
            cell.accessoryType = .none
        }

        config.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard case let .event(name, params, _) = filtered[indexPath.row] else { return }
        let vc = AnalyticsEventDetailViewController(name: name, params: params)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func copyJSON() {
        let json = buildStoreJSON()
        UIPasteboard.general.string = json
    }

    @objc private func shareJSON() {
        let text = buildStoreJSON()
        let ac = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(ac, animated: true)
    }

    // DebugAnalyticsStore -> JSON 문자열 생성
    private func buildStoreJSON() -> String {
        // 예시: store.records를 사람이 읽을 수 있는 딕셔너리 배열로 변환
        let rows: [[String: Any]] = DebugAnalyticsStore.shared.records.map { rec in
            switch rec {
            case let .event(name, params, ts):
                return [
                    "type": "event",
                    "name": name,
                    "parameters": params.map { jsonNormalize($0) } ?? [:],
                    "ts": jsonNormalize(ts)
                ]
            case let .userProperty(name, value, ts):
                return [
                    "type": "userProperty",
                    "name": name,
                    "value": jsonNormalize(value ?? "nil"),
                    "ts": jsonNormalize(ts)
                ]
            case let .userId(id, ts):
                return [
                    "type": "userId",
                    "id": jsonNormalize(id),
                    "ts": jsonNormalize(ts)
                ]
            case let .defaultParams(p, ts):
                return [
                    "type": "defaultParams",
                    "parameters": p.map { jsonNormalize($0) } ?? [:],
                    "ts": jsonNormalize(ts)
                ]
            }
        }
        return jsonString(from: rows)
    }


    private func prettyParams(_ p: [AnalyticsKey: Any]?) -> String {
        guard let p else { return "{}" }
        return p.map { "\($0.key.rawValue): \($0.value)" }.sorted().joined(separator: ", ")
    }

    private func timeString(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f.string(from: d)
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
            // 이미 String 키면 값만 정규화
            return v.reduce(into: [String: Any]()) { out, e in out[e.key] = jsonNormalize(e.value) }
        case let v as [AnalyticsKey: Any]:
            // 여기서가 핵심: AnalyticsKey -> String
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

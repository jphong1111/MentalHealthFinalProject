//
//  AppInfoViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG
import UIKit

final class AppInfoViewController: UITableViewController {
    private enum Row {
        case appVersion, buildNumber, bundleId, device, os, pushToken
    }
    private var items: [(title: String, value: String, copyable: Bool)] = []

    var pushTokenProvider: () -> String? = { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App Info"
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close,
            primaryAction: UIAction { _ in DebugPanelEnvironment.shared.onClose?() })
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "—"
        let build   = info?["CFBundleVersion"] as? String ?? "—"
        let bundle  = Bundle.main.bundleIdentifier ?? "—"
        let device  = UIDevice.current.model + " (\(UIDevice.current.name))"
        let os      = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        let token   = pushTokenProvider() ?? "—"

        items = [
            ("Version", version, true),
            ("Build", build, true),
            ("Bundle ID", bundle, true),
            ("Device", device, true),
            ("OS", os, true),
            ("Push Token", token, true),
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.secondaryText = item.value
        config.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = config
        cell.selectionStyle = item.copyable ? .default : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = items[indexPath.row].value
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
#endif

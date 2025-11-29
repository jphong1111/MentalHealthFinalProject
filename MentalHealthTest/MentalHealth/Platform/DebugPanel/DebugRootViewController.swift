//
//  DebugRootViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG
import UIKit

final class DebugRootViewController: UITableViewController {
    private enum Row: Int, CaseIterable {
        case userDefaults
        case appInfo
        case analytics
        case featureFlags

        var title: String {
            switch self {
                case .userDefaults:
                    return "UserDefaults List Edit"
                case .appInfo:
                    return "AppInfo"
                case .analytics:
                    return "Analytics Events"
                case .featureFlags:
                    return "Feature Flags"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SoliU DebugPanel"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction { _ in DebugPanelEnvironment.shared.onClose?() }
        )
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { Row.allCases.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = Row.allCases[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = row.title
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Row.allCases[indexPath.row] {
        case .userDefaults: navigationController?.pushViewController(UserDefaultsListViewController(), animated: true)
        case .appInfo:
            let vc = AppInfoViewController()
            // vc.pushTokenProvider = { AppDelegate.shared.pushToken } 
            navigationController?.pushViewController(vc, animated: true)
        case .analytics:    navigationController?.pushViewController(AnalyticsEventsViewController(), animated: true)
        case .featureFlags:
            return
            /*navigationController?.pushViewController(FeatureFlagsViewController(), animated: true)*/
        }
    }
}

#endif

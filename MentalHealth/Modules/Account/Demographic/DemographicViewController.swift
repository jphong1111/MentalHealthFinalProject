//
//  DemographicViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 9/13/25.
//

import UIKit

final class DemographicViewController: BaseViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)

    enum DemographicItem: Int, CaseIterable {
        case age, status, ethnicity

        var title: String {
            switch self {
            case .age: return .localized(.age)
            case .status: return .localized(.currentStatus)
            case .ethnicity: return .localized(.ethnicity)
            }
        }

        var detailType: DetailType {
            switch self {
            case .age:       return .age
            case .status:    return .workStatus
            case .ethnicity: return .ethnicity
            }
        }

        func value() -> String {
            if LoginManager.shared.isLoggedIn() {
                switch self {
                case .age:
                    return LoginManager.shared.getAge()
                case .status:
                    return LoginManager.shared.getWorkStatus()
                case .ethnicity:
                    return LoginManager.shared.getEthnicity()
                }
            } else {
                return "N/A"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SoliUColor.homepageBackground
        setCustomBackNavigationButton()
        setNavigationTitle(title: .localized(.demographics))
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        tableView.reloadData()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(DemographicItem.allCases.count) * 54)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(DemographicCell.self, forCellReuseIdentifier: DemographicCell.identifier)
    }
}

extension DemographicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemographicItem.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = DemographicItem(rawValue: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: DemographicCell.identifier, for: indexPath) as? DemographicCell
        else { return UITableViewCell() }

        cell.configure(title: item.title, value: item.value())
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return LoginManager.shared.isLoggedIn()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = DemographicItem(rawValue: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = DemographicDetailViewController()
        detailVC.model = DemographicDetailViewController.Model(title: .localized(item.title), type: item.detailType)
        navigate(detailVC)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

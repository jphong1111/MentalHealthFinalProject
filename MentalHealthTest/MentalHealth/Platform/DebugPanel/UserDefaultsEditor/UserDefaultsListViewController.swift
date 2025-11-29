//
//  UserDefaultsListViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG
import UIKit

final class UserDefaultsListViewController: UITableViewController, UISearchResultsUpdating {
    private var allItems: [(key: String, value: Any)] = []
    private var filtered: [(key: String, value: Any)] = []
    private let search = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UserDefaults"
        navigationItem.searchController = search
        search.searchResultsUpdater = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadData),
                                               name: UserDefaults.didChangeNotification, object: nil)
    }

    @objc private func reloadData() {
        let dict = UserDefaults.standard.dictionaryRepresentation()
        let sorted = dict.keys.sorted()
        allItems = sorted.map { ($0, dict[$0] as Any) }
        applyFilter()
    }

    func updateSearchResults(for searchController: UISearchController) { applyFilter() }

    private func applyFilter() {
        let q = (search.searchBar.text ?? "").lowercased()
        filtered = q.isEmpty
        ? allItems
        : allItems.filter {
            $0.key.lowercased().contains(q) ||
            String(describing: $0.value).lowercased().contains(q)
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filtered.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = filtered[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = item.key
        config.secondaryText = String(describing: item.value)
        config.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = filtered[indexPath.row]
        navigationController?.pushViewController(UserDefaultsEditorViewController(key: item.key, value: item.value), animated: true)
    }
}

#endif

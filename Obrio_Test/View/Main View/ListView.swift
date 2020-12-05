//
//  ListView.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import UIKit

struct ListViewData {
    var repos: [Repo]
}

class ListView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewData: ListViewData!
    
    func setupView(from vc: (UISearchBarDelegate & UISearchResultsUpdating), with viewData: ListViewData) {
        self.viewData = viewData
        setupTableView()
        setupSearchController(vc)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
    }
    
    private func setupSearchController(_ vc: (UISearchBarDelegate & UISearchResultsUpdating)) {
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = vc
        searchController.searchResultsUpdater = vc
    }
    
    func updateUI(viewData: ListViewData?) {
        if let data = viewData { self.viewData = data }
        tableView.reloadData()
    }

}
// MARK: - UITableViewDelegate
extension ListView: UITableViewDelegate { }
// MARK: - UITableViewDataSource
extension ListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: C.repoCellID, for: indexPath) as? RepoCell else { return UITableViewCell() }
        let repo = viewData.repos[indexPath.row]
        cell.cellData = CellData(name: repo.name,
                                 fullName: repo.fullName)
        return cell
    }
    
}

//
//  ListVC.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import UIKit

final class ListVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mainView: ListView!
    // MARK: - Properties
    private var repos: [Repo] = []
    private var requestService: RequestService?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.setupView(from: self, with: ListViewData(repos: repos))
        setupServices()
    }
    
    private func setupServices() {
        requestService = DependencyInjection.shared.requestService()
    }

}
// MARK: - UISearchBarDelegate
extension ListVC: UISearchBarDelegate { }
// MARK: - UISearchResultsUpdating
extension ListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        requestService?.fetchRepos(query: text, completionHandler: { [unowned self] repos in
            guard let repos = repos else { return }
            self.repos = repos
            DispatchQueue.main.async { [unowned self] in
                self.mainView.updateUI(viewData: ListViewData(repos: self.repos))
            }
        })
    }
    
}

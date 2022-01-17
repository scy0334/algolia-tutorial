//
//  ViewController.swift
//  AlgoliaSearchPractice
//
//  Created by Si Choi on 2022/01/16.
//

import UIKit
import InstantSearch

struct Item: Codable {
  let name: String
}

class ViewController: UIViewController {

    // MARK: - Properties
    lazy var searchController = UISearchController(searchResultsController: hitsViewController)
    
    let hitsViewController = SearchResultsViewController()
    
    // Searcher performs search requests and obtains search results
    let searcher = HitsSearcher(appID: "latency",
                                apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                indexName: "bestbuy")
    
    lazy var searchConnector = SearchConnector<Item>(searcher: searcher,
                                                     searchController: searchController,
                                                     hitsInteractor: .init(),
                                                     hitsController: hitsViewController,
    filterState: filterState)
    
    let statsInteractor = StatsInteractor()
    
    let filterState = FilterState()
    lazy var categoryConnector = FacetListConnector(searcher: searcher,
                                                    filterState: filterState,
                                                    attribute: "category",
                                                    operator: .and,
                                                    controller: categoryListController)
    
    lazy var categoryListController = FacetListTableController(tableView: categoryTableViewController.tableView)
    let categoryTableViewController = UITableViewController()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        searchConnector.connect() // activates the search connector
        categoryConnector.connect()
        searcher.search() // launch the first empty search request
        statsInteractor.connectSearcher(searcher) // shows the hit count
        statsInteractor.connectController(self)
        setupUI()
        configureHighlight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }

    // MARK: - Actions
    @objc func showFilters() {
      let navigationController = UINavigationController(rootViewController: categoryTableViewController)
      categoryTableViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissFilters))
      present(navigationController, animated: true, completion: .none)
    }
    
    @objc func dismissFilters() {
      categoryTableViewController.navigationController?.dismiss(animated: true, completion: .none)
    }

    // MARK: - Helpers
    func configureHighlight() {
        let settings = Settings()
          .set(\.attributesToHighlight, to: [
            "name",
          ])
        
    }
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = .init(title: "Category", style: .plain, target: self, action: #selector(showFilters))
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.showsSearchResultsController = true
        searchController.automaticallyShowsCancelButton = false
        categoryTableViewController.title = "Category"
      }
}

extension ViewController: StatsTextController {
  
  func setItem(_ item: String?) {
    title = item
  }

}

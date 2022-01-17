//
//  SearchResultsViewController.swift
//  AlgoliaSearchPractice
//
//  Created by Si Choi on 2022/01/16.
//

import UIKit
import InstantSearch

class SearchResultsViewController: UITableViewController, HitsController {
    
    var hitsSource: HitsInteractor<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hitsSource?.numberOfHits() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = hitsSource?.hit(atIndex: indexPath.row)?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = hitsSource?.hit(atIndex: indexPath.row) {
            // Handle hit selection
            
            print("DEBUG: tapped item \(item)")
        }
    }
    
}

//
//  SearchTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 12.10.2022.
//

import UIKit

class SearchTableViewController: UITableViewController {
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.titleView = searchBar
        searchBar.setUpSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

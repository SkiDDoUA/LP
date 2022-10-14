//
//  SearchTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 12.10.2022.
//

import UIKit

class SearchTableViewController: UITableViewController {
    var stockLoaded = false
    var orderLoaded = false
    private var database = Database()
    private var allproducts = [[UserProduct](), [UserProduct]()] {
       didSet {
           DispatchQueue.main.async {
               if self.stockLoaded && self.orderLoaded {
                   self.tableView.reloadData()
               }
           }
       }
    }
    var productsStock = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.stockLoaded = true
               self.allproducts[0] = self.productsStock
           }
       }
    }
    
    var productsOrder = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.orderLoaded = true
               self.allproducts[1] = self.productsOrder
           }
       }
    }

    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.titleView = searchBar
        searchBar.setUpSearchBar()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    //MARK: - Load Data From Database
    func loadData() {
        database.getProductsForSearch(availabilityCollection: .stock) { products in
            self.productsStock = products
        }
        
        database.getProductsForSearch(availabilityCollection: .order) { products in
            self.productsOrder = products
        }
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

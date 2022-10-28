//
//  SearchTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 12.10.2022.
//

import UIKit
import Foundation

class SearchTableViewController: UITableViewController {
    var stockLoaded = false
    var orderLoaded = false
    private var pendingRequestWorkItem: DispatchWorkItem?
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
    var spaceStrippedSearchText = String()
    var searchBrandSuggestions = [String]()
    private var tempAllproducts = [[UserProduct](), [UserProduct]()]

    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.setUpSearchBar()
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.addBottomLine()
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchBrandSuggestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        if let cell = cell as? FilterTableViewCell {
            cell.filterNameLabel?.text = searchBrandSuggestions[indexPath.row]
            cell.filtersLabel?.text = "Бренд"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

// MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        
        spaceStrippedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        
        // Show all the symbols when `spaceStrippedSearchText` is empty
        guard !spaceStrippedSearchText.isEmpty else {
            searchBrandSuggestions.removeAll()
            tableView.reloadData()
            print("#USER HISTORY SHOWING#")
            return
        }
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self!.searchBrandSuggestions.removeAll()
            self!.tableView.reloadData()
            
            // Filter all symbol names using a smart matching algorithm based on token prefixes
            let smartSearchMatcher = SearchEngine(searchString: self!.spaceStrippedSearchText)
            
            for (availabilityType, productsCollection) in self!.allproducts.enumerated() {
                self!.tempAllproducts[availabilityType] = productsCollection.filter { product in
                    if smartSearchMatcher.searchTokens.count == 1 && smartSearchMatcher.matches(product) {
                        return true
                    }
                    return smartSearchMatcher.matches(product)
                }
            }
            
            // Get brand suggestions
            for (availabilityType, _) in self!.tempAllproducts.enumerated() {
                self!.tempAllproducts[availabilityType] = self!.tempAllproducts[availabilityType].filter {
                    $0.product?.brand.name.lowercased().contains(searchText.lowercased()) ?? false
                }
            }
            
            // Prepare brand suggestions for TableView
            for (availabilityType, _) in self!.tempAllproducts.enumerated() {
                self!.tempAllproducts[availabilityType].forEach{self!.searchBrandSuggestions.append($0.product!.brand.name)}
            }
            self!.searchBrandSuggestions = Array(Set(self!.searchBrandSuggestions))
            self!.tableView.reloadData()
        }
                
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: requestWorkItem)
    }
}
//
//  SearchTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 12.10.2022.
//

import UIKit
import Foundation

class SearchTableViewController: UITableViewController {
    let searchBar = UISearchBar()
    var stockLoaded = false
    var orderLoaded = false
    var spaceStrippedSearchText = String()
    var searchBrandSuggestions = [String]()
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var database = Database()
    private var tempAllproducts = [[UserProduct](), [UserProduct]()]
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = " "
        searchBarAdditionalSetUp()
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
    
    //MARK: - Get Favorites For Search
    func getFavorites() {
        database.getFavoriteProductsForSearch(searchProducts: tempAllproducts) { products in
            self.tempAllproducts = products
            print("1")
        }
        print("2")
    }
    
    func searchBarAdditionalSetUp() {
        navigationItem.titleView = searchBar
        searchBar.setUpSearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Название, бренд, цвет, пол, сезон, материал"
        searchBar.setImage(UIImage(), for: .search, state: .normal)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBrandSuggestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
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
    
    //MARK: - Parse Filter Data To FilterSecondTableViewController And ShoppingViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toShopping":
            
            getFavorites()
            print("3")
            let destination = segue.destination as! ShoppingViewController
            
            if let cell = sender as? FilterTableViewCell {
                let indexPath = tableView.indexPath(for: cell)!
                let brandFilterStructure = ProductFilter(filterType: .brand, filterData: [Filter(filterString: searchBrandSuggestions[indexPath.row], isChosen: true)])
                destination.productsStock = FilterTableViewController().filterProducts(productsP: tempAllproducts[0], filters: [brandFilterStructure])
                destination.productsOrder = FilterTableViewController().filterProducts(productsP: tempAllproducts[1], filters: [brandFilterStructure])
                destination.titleString = searchBrandSuggestions[indexPath.row]
            } else {
                destination.productsStock = tempAllproducts[0]
                destination.productsOrder = tempAllproducts[1]
                destination.titleString = searchBar.searchTextField.text ?? ""
            }

        default: break
        }
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
            
            // Get brand suggestions
            for (availabilityType, _) in self!.allproducts.enumerated() {
                self!.tempAllproducts[availabilityType] = self!.allproducts[availabilityType].filter {
                    $0.product?.brand.name.lowercased().contains(searchText.lowercased()) ?? false
                }
            }
            
            // Prepare brand suggestions for TableView
            for (availabilityType, _) in self!.allproducts.enumerated() {
                self!.tempAllproducts[availabilityType].forEach{self!.searchBrandSuggestions.append($0.product!.brand.name)}
            }
            
            self!.searchBrandSuggestions = Array(Set(self!.searchBrandSuggestions))
            self!.tableView.reloadData()
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: requestWorkItem)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let spaceStrippedSearchText = searchBar.searchTextField.text?.trimmingCharacters(in: .whitespaces) else { return }

        // Filter all symbol names using a smart matching algorithm based on token prefixes
        let smartSearchMatcher = SearchEngine(searchString: spaceStrippedSearchText)
        
        for (availabilityType, productsCollection) in allproducts.enumerated() {
            tempAllproducts[availabilityType] = productsCollection.filter { product in
                if smartSearchMatcher.searchTokens.count == 1 && smartSearchMatcher.matches(product) {
                    return true
                }
                return smartSearchMatcher.matches(product)
            }
        }
        
        performSegue(withIdentifier: "toShopping", sender: nil)
    }
}

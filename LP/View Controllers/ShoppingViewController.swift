//
//  ShoppingViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 23.01.2022.
//

import UIKit
import WMSegmentControl

class ShoppingViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var availabilitySegmentedControl: WMSegment!
    @IBOutlet weak var productCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productCollectionViewConstraint: NSLayoutConstraint!
    
    private var database = Database()
    weak var delegate: FilterDataDelegate?
    var titleString = " "
    var shoppingFromSearch = false
    var productCollectionType: Database.productCollectionTypes?
    var filterType: FilterTypes?
    var tempProducts = [UserProduct]()
    var filterStructuresArray = [ProductFilter?]()
    var sortStructure: Sort?
    
    private var allproducts = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               let goodFilters = self.filterStructuresArray.compactMap{$0}
               if !goodFilters.isEmpty {
                   self.products = FilterTableViewController().filterProducts(productsP: self.allproducts, filters: goodFilters)
               } else {
                   self.products = self.allproducts
               }
           }
       }
    }
    
    var products = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.productCollectionView.reloadData()
           }
       }
    }
    
    var productsStock = [UserProduct]() {
        didSet {
            if !self.productsStock.isEmpty {
                shoppingFromSearch = true
            }
        }
    }
    var productsOrder = [UserProduct]() {
        didSet {
            if !self.productsOrder.isEmpty {
                shoppingFromSearch = true
            }
        }
    }
    
    var availabilityCollectionType: Database.availabilityCollectionTypes?  {
        didSet {
            DispatchQueue.main.async {
                if self.shoppingFromSearch == true {
                    if self.availabilityCollectionType == .stock {
                        self.allproducts = self.productsStock
                        self.tempProducts = self.productsStock
                    } else {
                        self.allproducts = self.productsOrder
                        self.tempProducts = self.productsOrder
                    }
                } else {
                    self.loadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = " "
        setUpSegmentedControl()

        if shoppingFromSearch == false {
            loadData()
        } else if !self.productsStock.isEmpty {
            availabilityCollectionType = .stock
            availabilitySegmentedControl.selectedSegmentIndex = 0
        } else {
            availabilityCollectionType = .order
            availabilitySegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = titleString
        navigationController?.addBottomLine()
    }
    
    //MARK: - Setup Product Collection View Constraints
    override func viewDidAppear(_ animated: Bool) {
        productCollectionViewHeightConstraint.constant = productCollectionView.contentSize.height
        productCollectionViewConstraint.constant = 35
    }
    
    //MARK: - Parse Cell Data To ProductViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toProduct":
            let destination = segue.destination as! ProductViewController
            let cell = sender as! ProductCollectionViewCell
            let indexPath = productCollectionView.indexPath(for: cell)!
            destination.product = products[indexPath.item]
        case "toFilter":
            let destination = segue.destination as! FilterTableViewController
            destination.delegate = self
            if !filterStructuresArray.isEmpty {
                destination.filterStructuresArray = filterStructuresArray
            }
            destination.allProducts = tempProducts
        case "toSort":
            let destination = segue.destination as! SortTableViewController
            destination.delegate = self
            if sortStructure != nil {
                destination.sortStructure = sortStructure!
            }
        default: break
        }
    }
    
    //MARK: - Load Data From Database
    func loadData() {
        database.getProductsWithFavorites(availabilityCollection: availabilityCollectionType ?? .stock, productCollection: productCollectionType ?? .pants) { products in
            self.allproducts = products
            self.tempProducts = products
        }
    }
    
    //MARK: - Setup SegmentedControl
    func setUpSegmentedControl() {
        availabilitySegmentedControl.selectorType = .bottomBar
        availabilitySegmentedControl.SelectedFont = UIFont(name: "Helvetica", size: 14)!
        availabilitySegmentedControl.normalFont = UIFont(name: "Helvetica", size: 14)!
    }
    
    //MARK: - Sort Products
    public func sortProducts(productsP: [UserProduct]) -> [UserProduct] {
        switch self.sortStructure?.sortType {
        case .recommendation:
            return productsP.sorted(by: {$0.product!.details.sizes.count > $1.product!.details.sizes.count})
        case .ascending:
            return productsP.sorted(by: {$0.product!.minPrice < $1.product!.minPrice})
        case .descending:
            return productsP.sorted(by: {$0.product!.minPrice > $1.product!.minPrice})
        default:
            return productsP
        }
    }
    
    // MARK: - Get Index From Segment
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        if sender.selectedSegmentIndex == 0 {
            availabilityCollectionType = .stock
        } else {
            availabilityCollectionType = .order
        }
        sortStructure = nil
        filterStructuresArray = []
    }
    
    // MARK: - Unwind Segue From Filter And Sort
    @IBAction func unwindToShopping(_ sender: UIStoryboardSegue) {}
}


// MARK: - UICollectionViewDelegate
extension ShoppingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
}

// MARK: - UICollectionViewDataSource
extension ShoppingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        cell.configure(for: self.products[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = productCollectionView.frame.size
        let value = (size.width-20)/2
        return CGSize(width: value, height: value*1.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - FilterDataDelegate
extension ShoppingViewController: FilterDataDelegate {
    func returnFilterData(filterArray: [ProductFilter?], filteredProducts: [UserProduct]) {
        filterStructuresArray = filterArray
        products = filteredProducts
    }
}

// MARK: - SortDataDelegate
extension ShoppingViewController: SortDataDelegate {
    func returnSortData(sort: Sort) {
        sortStructure = sort
        products = sortProducts(productsP: products)
    }
}

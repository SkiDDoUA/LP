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
    
    var titleString = " "
    var productCollectionType: Database.productCollectionTypes?
    var availabilityCollectionType: Database.availabilityCollectionTypes?
    var filterType: FilterTypes?
    private var database: Database?
    weak var delegate: FilterDataDelegate?
    var tempProducts = [UserProduct]()
    var filterStructuresArray = [ProductFilter?]()
    var sortStructure: Sort?
    var products = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.products = self.sortProducts(productsP: self.products)
               self.productCollectionView.reloadData()
           }
       }
    }
    private var allproducts = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.products = self.allproducts
           }
       }
    }
    
    public func sortProducts(productsP: [UserProduct]) -> [UserProduct] {
        switch self.sortStructure?.sortType {
        case .recommendation:
            return productsP.sorted(by: {$0.product!.details.size.count > $1.product!.details.size.count})
        case .lowprice:
            return productsP.sorted(by: {$0.product!.price < $1.product!.price})
        case .highprice:
            return productsP.sorted(by: {$0.product!.price > $1.product!.price})
        default:
            return productsP
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = titleString
        loadData()
    }
    
    //MARK: - Setup Product Collection View Constraints
    override func viewDidAppear(_ animated: Bool) {
        productCollectionViewHeightConstraint.constant = productCollectionView.contentSize.height
        productCollectionViewConstraint.constant = 35
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        availabilitySegmentedControl.selectorType = .bottomBar
        availabilitySegmentedControl.SelectedFont = UIFont(name: "Helvetica", size: 14)!
        availabilitySegmentedControl.normalFont = UIFont(name: "Helvetica", size: 14)!
    }
    
    //MARK: - Load Data From Database
    func loadData() {
        database = Database()
        database?.getProducts(availabilityCollection: availabilityCollectionType ?? .stock, productCollection: productCollectionType ?? .pants) { products in
            self.allproducts = products
            self.tempProducts = products
        }
        
        database?.getUserProducts(collection: .favorites) { favorites in
            for favorite in favorites {
                if let index = self.products.firstIndex(where: { $0.product!.reference.documentID == favorite.reference?.documentID }) {
                    self.products[index].isFavorite = true
                }
            }
        }
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
    
    // MARK: - Get Index From Segment
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        if sender.selectedSegmentIndex == 0 {
            availabilityCollectionType = .stock
        } else {
            availabilityCollectionType = .order
        }
        loadData()
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
        products = filteredProducts
        filterStructuresArray = filterArray
    }
}

// MARK: - SortDataDelegate
extension ShoppingViewController: SortDataDelegate {
    func returnSortData(sort: Sort) {
        sortStructure = sort
    }
}

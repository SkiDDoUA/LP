//
//  ShoppingViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 23.01.2022.
//

import UIKit
import WMSegmentControl

class ShoppingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterDataDelegate, SortDataDelegate {
    
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
    private let toProductIdentifier = "toProduct"
    var tempProducts = [StockProduct]()
    var filterStructuresArray = [ProductFilter?]()
    var products = [StockProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.productCollectionView.reloadData()
           }
       }
    }
    private var allproducts = [StockProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.products = self.allproducts
           }
       }
    }
    var sortStructure: Sort? {
       didSet {
           DispatchQueue.main.async {
               self.products = self.sortProducts(productsP: self.tempProducts)
           }
       }
    }
    
    public func sortProducts(productsP: [StockProduct]) -> [StockProduct] {
        switch self.sortStructure?.sortType {
        case .recommendation:
            return productsP.sorted(by: {$0.details.size.count > $1.details.size.count})
        case .lowprice:
            return productsP.sorted(by: {$0.price < $1.price})
        case .highprice:
            return productsP.sorted(by: {$0.price > $1.price})
        default:
            return productsP
        }
    }
    
    func returnSortData(sort: Sort) {
        sortStructure = sort
    }

    func returnFilterData(filterArray: [ProductFilter?], filteredProducts: [StockProduct]) {
        products = filteredProducts
        filterStructuresArray = filterArray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = titleString
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
        loadData()
    }
    
    //MARK: - Load Data From Database
    func loadData() {
        database = Database()
        database?.fetchData(availabilityCollection: availabilityCollectionType ?? Database.availabilityCollectionTypes.stock, productCollection: productCollectionType ?? Database.productCollectionTypes.pants) { products in
            self.allproducts = products
            self.tempProducts = products
        }
    }
    
    //MARK: - Extensions For Slider Collection View Cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
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
    
    //MARK: - Parse Cell Data To ProductViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toProductIdentifier:
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
                print(sortStructure)
                destination.sortStructure = sortStructure!
            }
        default: break
        }
    }
    
    // MARK: - Get Index From Segment
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        if sender.selectedSegmentIndex == 0 {
            availabilityCollectionType = Database.availabilityCollectionTypes.stock
        } else {
            availabilityCollectionType = Database.availabilityCollectionTypes.order
        }
        loadData()
    }
    
    // MARK: - Unwind Segue From Filter And Sort
    @IBAction func unwindToShopping(_ sender: UIStoryboardSegue) {}
}

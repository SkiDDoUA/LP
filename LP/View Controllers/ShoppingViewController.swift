//
//  ShoppingViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 23.01.2022.
//

import UIKit
import WMSegmentControl

class ShoppingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var availabilitySegmentedControl: WMSegment!
    @IBOutlet weak var productCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productCollectionViewConstraint: NSLayoutConstraint!
    
    var titleString = " "
    var productCollectionType: Database.productCollectionTypes?
    var availabilityCollectionType: Database.availabilityCollectionTypes?
    var filterType: FilterTypes?
    private var database: Database?
    private let toProductIdentifier = "toProduct"
    var tempProducts = [StockProduct]()
//    var SSS = [[], [], [], [], []]
    //            var brands = ["Heron Preston", "Calvin Klein"]
    //            print(products.filter({brands.contains($0.brand.name)}))
                
    //            var sizes = ["S", "M"]
    //            print(products.filter({$0.details.size.contains(where: sizes.contains)}))
                
    //            var colors = ["белый", "черный"]
    //            print(products.filter({colors.contains($0.details.color)}))
                
    //            var gender = ["men"]
    //            print(products.filter({gender.contains($0.details.gender)}))
                
    //            var fromPrice = 1000
    //            var toPrice = 4000
    //            print(products.filter({fromPrice <= $0.price && $0.price <= toPrice}))
    
//    var SSS = [["S", "M"], ["1000", "4000"], ["Женский", "Мужской"], ["Белый", "Черный"], ["Heron Preston", "Calvin Klein"]]
//
//    var filterStructureArray = [ProductFilter]() {
//       didSet {
//           DispatchQueue.main.async {
////               for filter in self.filterStructureArray {
////                   switch filter.filterType {
////                   case .size:
////                       <#code#>
////                   case .price:
////                       <#code#>
////                   case .gender:
////                       <#code#>
////                   case .color:
////                       <#code#>
////                   default:
////                       <#code#>
////                   }
////               }
//               print("?????????")
//               self.products = self.tempProducts.filter {
//                   $0.details.size.contains(where: self.SSS[0].contains) &&
//                   (Int(self.SSS[1][0]) ?? 0 <= $0.price && $0.price <= Int(self.SSS[1][1]) ?? 0) &&
//                   self.SSS[2].contains($0.details.gender) &&
//                   self.SSS[3].contains($0.details.color) &&
//                   self.SSS[4].contains($0.brand.name)
//               }
////               self.products = self.tempProducts.filter({$0.details.size.contains(where: self.chosenFilters.contains)})
//           }
//       }
//    }
    
    var SSS = [["S", "M"], ["1000", "4000"], ["Женский", "Мужской"], ["Белый", "Черный"], ["Heron Preston", "Calvin Klein"]]
    
    var filterStructureArray = [ProductFilter]() {
       didSet {
           DispatchQueue.main.async {
               print("?????????")
               self.products = self.tempProducts.filter {
                   $0.details.size.contains(where: self.SSS[0].contains) &&
                   (Int(self.SSS[1][0]) ?? 0 <= $0.price && $0.price <= Int(self.SSS[1][1]) ?? 0) &&
                   self.SSS[2].contains($0.details.gender) &&
                   self.SSS[3].contains($0.details.color) &&
                   self.SSS[4].contains($0.brand.name)
               }
           }
       }
    }
    
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
    
    //MARK: - Setup Product Collection View Constraints
    override func viewDidAppear(_ animated: Bool) {
        productCollectionViewHeightConstraint.constant = productCollectionView.contentSize.height
        productCollectionViewConstraint.constant = 35
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        title = titleString
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
            destination.products = tempProducts
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
    
    // MARK: - Unwind Segue From Filter
    @IBAction func unwindToShopping(_ sender: UIStoryboardSegue) {}
}

//
//  MainViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 24.12.2021.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var pageViewControl: UIPageControl!
    
    @IBOutlet weak var productCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var outerwearButton: UIButton!
    @IBOutlet weak var tshirtsButton: UIButton!
    @IBOutlet weak var pantsButton: UIButton!
    @IBOutlet weak var shoesButton: UIButton!
    @IBOutlet weak var hoodieButton: UIButton!
    @IBOutlet weak var sweatshirtsButton: UIButton!
    @IBOutlet weak var hatsButton: UIButton!
    @IBOutlet weak var accessoriesButton: UIButton!
    @IBOutlet weak var bagsButton: UIButton!
    @IBOutlet weak var underwearButton: UIButton!
    
    var titleString = " "
    var productCollectionType: Database.productCollectionTypes?
    var availabilityCollectionType: Database.availabilityCollectionTypes?
    var timer = Timer()
    var counter = 0
    var imageArray = [UIImage(named: "Rec1"), UIImage(named: "Rec2"), UIImage(named: "Rec3")]
    private let toProductIdentifier = "toProduct"
    private let toShoppingIdentifier = "toShopping"
    private var database: Database?
    
    var products = [Product]() {
       didSet {
           DispatchQueue.main.async {
               self.productCollectionView.reloadData()
           }
       }
    }
    
    private var allproducts = [Product]() {
       didSet {
           DispatchQueue.main.async {
               self.products = self.allproducts
           }
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Setup View
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.titleView = searchBar
        searchBar.searchTextField.layer.cornerRadius = 15
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.backgroundImage = UIImage()
        
        //MARK: - Setup Slider
        pageViewControl.numberOfPages = imageArray.count
        pageViewControl.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        loadData()
    }
    
    //MARK: - Setup Product Collection View Constraints
    override func viewDidAppear(_ animated: Bool) {
        productCollectionViewHeightConstraint.constant = productCollectionView.contentSize.height
        productCollectionViewConstraint.constant = 35
    }
    
    //MARK: - Load Data From Database
    func loadData() {
        database = Database()
        database?.fetchData(availabilityCollection: availabilityCollectionType ?? Database.availabilityCollectionTypes.stock, productCollection: productCollectionType ?? Database.productCollectionTypes.pants) { products in
            self.allproducts = products
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
            
        }
    }
    
    //MARK: - Auto Image Change
    @objc func changeImage() {
     if counter < imageArray.count {
         let index = IndexPath.init(item: counter, section: 0)
         self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         pageViewControl.currentPage = counter
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         pageViewControl.currentPage = counter
         counter = 1
     }
    }
        
    //MARK: - Extensions For Slider Collection View Cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.sliderCollectionView {
            return imageArray.count
        }
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                vc.image = imageArray[indexPath.row]
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
            cell.configure(for: self.products[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.sliderCollectionView {
            let size = sliderCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        } else {
            let size = productCollectionView.frame.size
            let value = (size.width-20)/2
            return CGSize(width: value, height: value*1.5)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.sliderCollectionView {
            return 0.0
        } else {
            return 10.0
        }
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
        case toShoppingIdentifier:
            let destination = segue.destination as! ShoppingViewController
            destination.titleString = titleString
            destination.productCollectionType = productCollectionType
        default: break
        }
    }
    
    // MARK: - Category Button Picker
    @IBAction func buttonClicked(sender: UIButton) {
        switch sender {
        case outerwearButton:
            titleString = outerwearButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.outerwear
        case tshirtsButton:
            titleString = tshirtsButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.tshirts
        case pantsButton:
            titleString = pantsButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.pants
        case shoesButton:
            titleString = shoesButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.shoes
        case hoodieButton:
            titleString = hoodieButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.hoodie
        case sweatshirtsButton:
            titleString = sweatshirtsButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.sweatshirts
        case hatsButton:
            titleString = hatsButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.hats
        case accessoriesButton:
            titleString = accessoriesButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.accessories
        case bagsButton:
            titleString = bagsButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.bags
        case underwearButton:
            titleString = underwearButton.titleLabel!.text!
            productCollectionType = Database.productCollectionTypes.underwear
        default: break
        }
        if sender != outerwearButton {
            self.performSegue(withIdentifier: toShoppingIdentifier, sender: Any?.self)
        }
    }
}

//MARK: - @IBDesignable For Button In Horizontal Menu
@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

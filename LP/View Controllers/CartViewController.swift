//
//  CartViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 02.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import DLRadioButton
import InputMask
import ValidationComponents

class CartViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableView: UIView!
    @IBOutlet weak var expandableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var streetView: UIView!
    @IBOutlet weak var flatView: UIView!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var firstNameTextField: СustomUITextField!
    @IBOutlet weak var lastNameTextField: СustomUITextField!
    @IBOutlet weak var patronymicTextField: СustomUITextField!
    @IBOutlet weak var phoneTextField: СustomUITextField!
    @IBOutlet weak var cityTextField: СustomUITextField!
    @IBOutlet weak var streetTextField: СustomUITextField!
    @IBOutlet weak var buildingTextField: СustomUITextField!
    @IBOutlet weak var flatTextField: СustomUITextField!
    @IBOutlet weak var orderCommentTextField: СustomUITextField!
    @IBOutlet weak var promocodeTextField: СustomUITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var patronymicErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var streetErrorLabel: UILabel!
    @IBOutlet weak var buildingErrorLabel: UILabel!
    @IBOutlet weak var flatErrorLabel: UILabel!
    @IBOutlet weak var orderCommentErrorLabel: UILabel!
    @IBOutlet weak var promocodeErrorLabel: UILabel!
    @IBOutlet weak var clothingPriceLabel: UILabel!
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    @IBOutlet var listener: MaskedTextFieldDelegate!

    private var database: Database?
    private let toProductIdentifier = "toProduct"
    var viewHeightConstraint: NSLayoutConstraint?
    var npPostalOffice: Bool?
    var clothingPrice = 0
    var deliveryPrice = 0
    var promocodeDiscount = 0
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.firstNameTextField.text = self.user?.contactInfo?.firstName
                self.lastNameTextField.text = self.user?.contactInfo?.lastName
                self.patronymicTextField.text = self.user?.contactInfo?.patronymic
                self.phoneTextField.text = self.user?.contactInfo?.phone
            }
        }
     }

    var totalPrice: Int {
        get {
            clothingPrice + deliveryPrice - promocodeDiscount
        }
    }
    var products = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.productsTableView.reloadData()
               self.clothingPrice = 0
               self.deliveryPrice = 0
               self.promocodeDiscount = 0
               
               for product in self.products {
                   self.clothingPrice += product.product!.price
               }
               self.clothingPriceLabel.text = "₴\(self.clothingPrice)\n₴\(self.deliveryPrice)\n₴\(self.promocodeDiscount)"
               self.orderTotalPriceLabel.text = "₴\(self.totalPrice)"
           }
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Корзина"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        listener.affinityCalculationStrategy = .prefix
        listener.affineFormats = ["[000000000]"]
        productsTableView.dataSource = self
        viewHeightConstraint = expandableView.heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
        expandableView.isHidden = true
        expandableViewBottomConstraint.constant = 0.0
        getCart()
    }
    
    func getCart() {
        database = Database()
        database?.getUserProducts(collection: .cart) {
            products in self.products = products;
        }
        
        database?.getUserDetails() { userData in self.user = userData }
    }
    
    @IBAction func postalOfficeDeliveryButtonTapped(_ sender: Any) {
        npPostalOffice = true
        viewHeightConstraint?.isActive = false
        expandableView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        expandableView.isHidden = false
        expandableViewBottomConstraint.constant = 20.0
        cityTextField.text = user?.contactInfo?.npPostalOffice?.city
        buildingTextField.text = user?.contactInfo?.npPostalOffice?.postalOffice
        buildingLabel.text = "НОМЕР ОТДЕЛЕНИЯ"
        buildingTextField.keyboardType = .numberPad
        streetView.isHidden = true
        flatView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func courierDeliveryButtonTapped(_ sender: Any) {
        npPostalOffice = false
        viewHeightConstraint?.isActive = false
        expandableView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        expandableView.isHidden = false
        expandableViewBottomConstraint.constant = 20.0
        cityTextField.text = user?.contactInfo?.npCourier?.city
        streetTextField.text = user?.contactInfo?.npCourier?.street
        buildingTextField.text = user?.contactInfo?.npCourier?.building
        flatTextField.text = self.user?.contactInfo?.npCourier?.flat
        buildingTextField.keyboardType = .default
        buildingLabel.text = "ЗДАНИЕ"
        streetView.isHidden = false
        flatView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func paymentButtonTapped(_ sender: Any) {
        var deliveryType: Any
        var contactInfo: ContactInfo?
        let firstName = firstNameTextField.fieldValidation(label: firstNameErrorLabel, ValidatorStructure: .field)
        let lastName = lastNameTextField.fieldValidation(label: lastNameErrorLabel, ValidatorStructure: .field)
        let patronymic = patronymicTextField.fieldValidation(label: patronymicErrorLabel, ValidatorStructure: .field)
        let phone = phoneTextField.fieldValidation(label: phoneErrorLabel, ValidatorStructure: .phone)
        
        if npPostalOffice == true {
            let city = cityTextField.fieldValidation(label: cityErrorLabel, ValidatorStructure: .field)
            let postalOffice = buildingTextField.fieldValidation(label: buildingErrorLabel, ValidatorStructure: .field)
            if city != ""  && postalOffice != "" {
                deliveryType = NpPostalOffice(city: city, postalOffice: postalOffice)
                contactInfo = ContactInfo(firstName: firstName, lastName: lastName, patronymic: patronymic, phone: phone, npPostalOffice: deliveryType as? NpPostalOffice)
            }
        } else {
            let city = cityTextField.fieldValidation(label: cityErrorLabel, ValidatorStructure: .field)
            let street = streetTextField.fieldValidation(label: streetErrorLabel, ValidatorStructure: .field)
            let building = buildingTextField.fieldValidation(label: buildingErrorLabel, ValidatorStructure: .field)
            let flat = flatTextField.fieldValidation(label: flatErrorLabel, ValidatorStructure: .field)
            if firstName != "" && lastName != "" && patronymic != "" && phone != "" && city != "" && street != "" && building != "" && flat != "" {
                deliveryType = NpCourier(city: city, street: street, building: building, flat: flat)
                contactInfo = ContactInfo(firstName: firstName, lastName: lastName, patronymic: patronymic, phone: phone, npCourier: deliveryType as? NpCourier)
            }
        }
        
        guard let orderInfo = contactInfo?.firstName else {
            return
        }
        
        if orderInfo.isEmpty != true {
            let comment = orderCommentTextField.text
            let promocode = promocodeTextField.text
            let order = Order(products: products, deliveryInfo: contactInfo, comment: comment, promocode: promocode, clothingPrice: clothingPrice, deliveryPrice: deliveryPrice, promocodeDiscountPrice: promocodeDiscount, totalPrice: totalPrice, status: .processing, createdAt: Date())
            database?.addUserOrder(order: order)
        }
    }
    
    //MARK: - Parse Cell Data To ProductViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toProductIdentifier:
            let destination = segue.destination as! ProductViewController
            let cell = sender as! CartProductTableViewCell
            let indexPath = productsTableView.indexPath(for: cell)!
            destination.product = products[indexPath.item]
        default: break
        }
    }
    
    // MARK: - TapGesture
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsTableViewConstraint.constant = 160.0 * CGFloat(products.count)
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartProductTableViewCell
        cell.configure(for: self.products[indexPath.row])
        if (indexPath.row == self.products.count-1) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0);
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            database?.removeUserProduct(collection: .cart, productReference: products[indexPath.row].reference!)
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

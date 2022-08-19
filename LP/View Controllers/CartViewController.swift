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

class CartViewController: UIViewController {
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
    
    
    private var database: Database?
    var viewHeightConstraint: NSLayoutConstraint?
    var products = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.productsTableView.reloadData()
           }
       }
    }
    
    func getCart() {
      //override the label with the parameter received in this method
        database = Database()
        database?.getUserProducts(collection: Database.userProductsCollectionTypes.cart) {
            products in self.products = products;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        productsTableView.dataSource = self
        viewHeightConstraint = expandableView.heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
        expandableView.isHidden = true
        expandableViewBottomConstraint.constant = 0.0
    }
    
    @IBAction func departmentDeliveryButtonTapped(_ sender: Any) {
        viewHeightConstraint?.isActive = false
        expandableView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        expandableView.isHidden = false
        expandableViewBottomConstraint.constant = 20.0
        buildingTextField.placeholder = "Укажите ваше отделение Новой Почты"
        buildingLabel.text = "НОМЕР ОТДЕЛЕНИЯ"
        buildingTextField.text = ""
        buildingTextField.keyboardType = .numberPad
        streetView.isHidden = true
        flatView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func courierDeliveryButtonTapped(_ sender: Any) {
        viewHeightConstraint?.isActive = false
        expandableView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        expandableView.isHidden = false
        expandableViewBottomConstraint.constant = 20.0
        buildingTextField.placeholder = "Укажите ваше здание"
        buildingTextField.text = ""
        buildingTextField.keyboardType = .default
        buildingLabel.text = "ЗДАНИЕ"
        streetView.isHidden = false
        flatView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - TapGesture
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
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
            database?.removeUserProduct(collection: Database.userProductsCollectionTypes.cart, productReference: products[indexPath.row].reference)
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

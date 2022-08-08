//
//  CartViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 02.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CartViewController: UIViewController {
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableViewConstraint: NSLayoutConstraint!
    
    private var database: Database?
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

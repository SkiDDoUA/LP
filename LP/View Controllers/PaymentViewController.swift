//
//  CartViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 02.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PaymentViewController: UIViewController {
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableViewConstraint: NSLayoutConstraint!
    
    private var database: Database?
    var productsReferences = [String : DocumentReference]()
    var sizes = [String]()
    var products = [Product]() {
       didSet {
           DispatchQueue.main.async {
               self.sizes = Array(self.productsReferences.keys)
               self.productsTableView.reloadData()
           }
       }
    }
    
    func setUser(_ userData: User) {
      //override the label with the parameter received in this method
        database = Database()
//        database?.getUserFavorites(docReference: (userData.cart)) {
//            products, productsReferences in self.products = products;
//                                            self.productsReferences = productsReferences
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsTableViewConstraint.constant = 160.0 * CGFloat(products.count)
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartProductTableViewCell
        cell.configure(for: self.products[indexPath.row], size: sizes[indexPath.row])
        if (indexPath.row == self.products.count-1) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0);
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            if products.count == productsReferences.count {
//                database?.removeFavoriteProduct(userID: userID, productReference: productsReferences[indexPath.row])
//                products.remove(at: indexPath.row)
//                productsReferences.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
        }
    }

}

// MARK: - UITableViewDelegate
//extension CartViewController: UITableViewDelegate {
//}

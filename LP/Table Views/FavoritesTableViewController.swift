//
//  FavoritesTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 11.06.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavoritesTableViewController: UITableViewController {
    private var database: Database?
    private let toProductIdentifier = "toProduct"
    var productsReferences = [[String : DocumentReference]]()
    var userID = Auth.auth().currentUser!.uid
    var sizes = [String]()
    var products = [FavoriteProduct]() {
       didSet {
           DispatchQueue.main.async {
//               self.sizes = Array(self.productsReferences.keys)
               self.tableView.reloadData()
           }
       }
    }
    
    func setUser(_ userData: String) {
      //override the label with the parameter received in this method
        database = Database()
//        let user = Auth.auth().currentUser!.uid
        database?.getUserFavorites(userID: (userData)) {
            products in self.products = products;
            print(products)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteProductTableViewCell
//        cell.configure(for: self.products[indexPath.row], size: sizes[indexPath.row])
        if (indexPath.row == self.products.count-1) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0);
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if products.count == productsReferences.count {
//                let productValuesArray =  Array(productsReferences.values)
//                let productKeysArray =  Array(productsReferences.keys)
//                print(productValuesArray[indexPath.row])
//                database?.removeFavoriteProduct(userID: userID, productReference: productValuesArray[indexPath.row])
//                products.remove(at: indexPath.row)
//                productsReferences.removeValue(forKey: productKeysArray[indexPath.row])
//                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    //MARK: - Parse Cell Data To ProductViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toProduct":
            let destination = segue.destination as! ProductViewController
            let cell = sender as! FavoriteProductTableViewCell
            let indexPath = tableView.indexPath(for: cell)!
//            destination.product = products[indexPath.item]
        default: break
        }
    }

}

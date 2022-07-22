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
    var productsReferences = [DocumentReference]()
    var userID = Auth.auth().currentUser!.uid
    var products = [Product]() {
       didSet {
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
       }
    }
    
    func setUser(_ userData: User) {
      //override the label with the parameter received in this method
        database = Database()
        database?.getUserFavorites(docReference: (userData.favorites)) {
            products, productsReferences in self.products = products;
                                            self.productsReferences = productsReferences
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
        cell.configure(for: self.products[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if products.count == productsReferences.count {
                database?.removeFavoriteProduct(userID: userID, productReference: productsReferences[indexPath.row])
                products.remove(at: indexPath.row)
                productsReferences.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
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
            destination.product = products[indexPath.item]
        default: break
        }
    }

}

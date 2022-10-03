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
    private var database = Database()
    private let toProductIdentifier = "toProduct"
    var products = [UserProduct]() {
       didSet {
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
       }
    }
    
    func getFavorites() {
        database.getUserProducts(collection: .favorites) {
            products in self.products = products;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        getFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Избранное"
        navigationController?.addBottomLine()
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
        if (indexPath.row == self.products.count-1) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0);
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0);
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            database.removeUserProduct(collection: .favorites, productReference: products[indexPath.row].reference!)
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    //MARK: - Parse Cell Data To ProductViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toProductIdentifier:
            let destination = segue.destination as! ProductViewController
            let cell = sender as! FavoriteProductTableViewCell
            let indexPath = tableView.indexPath(for: cell)!
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

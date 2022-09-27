//
//  OrdersTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 25.08.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OrdersTableViewController: UITableViewController {
    private var database: Database?
    private let toOrderIdentifier = "toOrderDetails"
    var orders = [Order]() {
       didSet {
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
       }
    }
    
    func getOrders() {
        database = Database()
        database?.getUserOrders() {
            orders in self.orders = orders;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Мои заказы"
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.addBottomLine()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getOrders()
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell", for: indexPath) as! OrderHistoryTableViewCell
        cell.configure(for: self.orders[indexPath.row])
        if (indexPath.row == self.orders.count-1) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0);
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0);
        }
        return cell
    }

    //MARK: - Parse Cell Data To OrderDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toOrderIdentifier:
            let destination = segue.destination as! OrderDetailsViewController
            let cell = sender as! OrderHistoryTableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            destination.order = orders[indexPath.item]
        default: break
        }
    }
}

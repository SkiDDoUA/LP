//
//  OrderViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 21.08.2022.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderContactInfoLabel: UILabel!
    @IBOutlet weak var clothingPriceLabel: UILabel!
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    
    var order: Order!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Детали заказа"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        self.productsTableView.delegate = self
        self.productsTableView.dataSource = self
        
        var deliveryType = "Доставка в отделение Новой почтой"
        var deliveryAddress = ""
        if order.deliveryInfo?.npPostalOffice != nil {
            deliveryAddress = "\(order.deliveryInfo!.npPostalOffice!.city), Отделение №\(order.deliveryInfo!.npPostalOffice!.postalOffice)"
        } else {
            deliveryType = "Доставка курьером"
            deliveryAddress = "\(order.deliveryInfo!.npCourier!.city), \(order.deliveryInfo!.npCourier!.street) \(order.deliveryInfo!.npCourier!.building), \(order.deliveryInfo!.npCourier!.flat!)"
        }
        
        orderContactInfoLabel.text = "\(deliveryType)\n\(deliveryAddress)\n\(order.deliveryInfo!.firstName) \(order.deliveryInfo!.lastName) \(order.deliveryInfo!.patronymic) \n\(order.deliveryInfo!.phone)"
        clothingPriceLabel.text = "₴\(order.clothingPrice)\n₴\(order.deliveryPrice)\n₴\(order.promocodeDiscountPrice)"
        orderTotalPriceLabel.text = "₴\(order.totalPrice)"
    }
}

// MARK: - UICollectionViewDelegate
extension OrderDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsTableViewConstraint.constant = 160.0 * CGFloat(order.products.count)
        return order.products.count
    }
}

// MARK: - UITableViewDataSource
extension OrderDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderProductTableViewCell
        cell.configure(for: self.order.products[indexPath.row])
        if (indexPath.row == self.order.products.count-1) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0);
        }
        return cell
    }
}

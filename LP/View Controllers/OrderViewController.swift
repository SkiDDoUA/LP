//
//  OrderViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 21.08.2022.
//

import UIKit

class OrderViewController: UIViewController {
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemsPriceLabel: UILabel!
    @IBOutlet weak var orderTotalPriceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

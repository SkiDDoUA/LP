//
//  FilterTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.02.2022.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    @IBOutlet weak var sizeCell: UITableViewCell!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var genderCell: UITableViewCell!
    @IBOutlet weak var colorCell: UITableViewCell!
    @IBOutlet weak var brandCell: UITableViewCell!
    
    var products = [StockProduct]()
    var filterData = [String]()
    var titleString = " "
    var selectedIndexPath: IndexPath = IndexPath()
    private let toSecondFilterIdentifier = "toSecondFilter"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = " "
        title = "Фильтр"
    }
    
    //MARK: - Prepare Filter Data Before Segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            products.forEach{filterData.append($0.price.description)}
            titleString = "Цена"
        case 2:
            products.forEach{filterData.append($0.details.gender)}
            titleString = "Пол"
        case 3:
            products.forEach{filterData.append($0.details.color)}
            titleString = "Цвет"
        case 4:
            products.forEach{filterData.append($0.brand.name)}
            titleString = "Бренд"
        default: break
        }
        
        if indexPath.row != 0 {
            self.performSegue(withIdentifier: toSecondFilterIdentifier, sender: Any?.self)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndexPath = indexPath
        return indexPath
    }
    
    //MARK: - Parse Filter Data To FilterSecondTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case toSecondFilterIdentifier:
                if selectedIndexPath.row == 0 {
                    products.forEach{filterData.append(contentsOf: $0.details.size)}
                    titleString = "Размер"
                }

                let destination = segue.destination as! FilterSecondTableViewController
                destination.filterData = Array(Set(filterData))
                destination.titleString = titleString
                filterData = []
            default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

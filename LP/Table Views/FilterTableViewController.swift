//
//  FilterTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.02.2022.
//

import UIKit

class FilterTableViewController: UITableViewController, FilterChosenDelegate {
    
    @IBOutlet weak var sizeCell: UITableViewCell!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var genderCell: UITableViewCell!
    @IBOutlet weak var colorCell: UITableViewCell!
    @IBOutlet weak var brandCell: UITableViewCell!
    
    var products = [StockProduct]()
    var filterData = [String]()
    var filterType: filterTypes?
    var chosenFilters = [String]()
    var buttonTapped = false
    var selectedIndexPath: IndexPath = IndexPath()
    private let toSecondFilterIdentifier = "toSecondFilter"
    
    var filterSizeData = [String]()
    var filterPriceData = [String]()
    var filterGenderData = [String]()
    var filterColorData = [String]()
    var filterBrandData = [String]()

    enum filterTypes: String {
        case size = "Размер"
        case price = "Цена"
        case gender = "Пол"
        case color = "Цвет"
        case brand = "Бренд"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addResultButtonView()
        self.navigationController?.navigationBar.topItem?.title = " "
        title = "Фильтр"
    }
    
    func userDidChoseFilters(filters: [String], type: filterTypes?) {
        switch type {
        case .size:
            filterSizeData = filters
        case .price:
            filterPriceData = filters
        case .gender:
            filterGenderData = filters
        case .color:
            filterColorData = filters
        default:
            filterBrandData = filters
        }
    }
    
    func addResultButtonView() {
        let resultButton = UIButton()

        resultButton.backgroundColor = UIColor(named: "BlackLP")
        resultButton.setTitle("Показать результаты", for: .normal)
        resultButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 14)
        resultButton.addTarget(self, action: #selector(resultTapped), for: .touchUpInside)
        tableView.addSubview(resultButton)

        // set position
        resultButton.translatesAutoresizingMaskIntoConstraints = false
        resultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        resultButton.widthAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.widthAnchor, constant: -30).isActive = true
        resultButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //MARK: - Prepare Filter Data Before Segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            products.forEach{filterData.append($0.price.description)}
            filterType = filterTypes.price
        case 2:
            products.forEach{filterData.append($0.details.gender)}
            filterType = filterTypes.gender
        case 3:
            products.forEach{filterData.append($0.details.color)}
            filterType = filterTypes.color
        case 4:
            products.forEach{filterData.append($0.brand.name)}
            filterType = filterTypes.brand
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
    
    // MARK: - Parse Chosen Filters
    @IBAction func resultTapped(_ sender: Any) {
        buttonTapped = true
        self.performSegue(withIdentifier: "unwindToShopping", sender: Any?.self)
    }
    
    //MARK: - Parse Filter Data To FilterSecondTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toSecondFilterIdentifier:
            if selectedIndexPath.row == 0 {
                products.forEach{filterData.append(contentsOf: $0.details.size)}
                filterType = filterTypes.size
            }

            let destination = segue.destination as! FilterSecondTableViewController
            destination.filterData = Array(Set(filterData))
            destination.filterType = filterType
            destination.delegate = self
            filterData = []
        case "unwindToShopping":
            let destination = segue.destination as! ShoppingViewController
            destination.chosenFilters = filterSizeData
            destination.filterType = filterType
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

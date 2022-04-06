//
//  FilterTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.02.2022.
//

import UIKit

class FilterTableViewController: UITableViewController, FilterChosenDelegate {    
    
    var products = [StockProduct]()
    var tempProducts = [StockProduct]()
    var chosenFilters = [String]()
    var buttonTapped = false
    var selectedIndexPath: IndexPath = IndexPath()
    private let toSecondFilterIdentifier = "toSecondFilter"
    var filterStructure: ProductFilter?
    var tempFilterStructure = [ProductFilter?]()

    
    var filterStructuresArray = [ProductFilter?](repeatElement(nil, count: FilterTypes.allFilters.count)) {
       didSet {
           DispatchQueue.main.async {
//               print(self.products)
//               print(self.filterStructuresArray)
               self.products = self.tempProducts.filter {
                   for filter in 0..<self.filterStructuresArray.count {
                       switch filter {
                       case 0:
                           return true
                       default:
                           return true
                       }
                   }
//                   if self.filterStructuresArray[0] != nil {
//                       self.filterStructuresArray[0]!.isUsed = true
//                       return $0.details.size.contains(where: self.filterStructuresArray[0]!.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains)
//                   }
//                   return false
//                   (Int(self.SSS[1][0]) ?? 0 <= $0.price && $0.price <= Int(self.SSS[1][1]) ?? 0) &&
//                   ((self.filterStructuresArray[2]?.filterData.map{$0.filterString}.contains($0.details.gender)) != nil) &&
//                   ((self.filterStructuresArray[3]?.filterData.map{$0.filterString}.contains($0.details.color)) != nil) &&
//                   ((self.filterStructuresArray[4]?.filterData.map{$0.filterString}.contains($0.brand.name)) != nil)
               }
               print(self.products)
           }
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addResultButtonView()
        self.navigationController?.navigationBar.topItem?.title = " "
        title = "Фильтр"
        
        tempProducts = products
    }
    
    func userDidChoseFilters(filter: ProductFilter) {
        filterStructuresArray[filter.filterType.details.index] = filter
        let indexPath = IndexPath(item: filter.filterType.details.index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    public func addResultButtonView() {
        let resultButton = UIButton()
        resultButton.backgroundColor = UIColor(named: "BlackLP")
        resultButton.setTitle("Показать результаты", for: .normal)
        resultButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 14)
        resultButton.addTarget(self, action: #selector(resultTapped), for: .touchUpInside)
        tableView.addSubview(resultButton)
        resultButton.translatesAutoresizingMaskIntoConstraints = false
        resultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        resultButton.widthAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.widthAnchor, constant: -30).isActive = true
        resultButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterStructuresArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        if let cell = cell as? FilterTableViewCell {
            cell.filterNameLabel?.text = FilterTypes.allFilters[indexPath.row].details.title
            if filterStructuresArray[indexPath.row] != nil {
                let returnedChosenFilters = filterStructuresArray[indexPath.row]!.filterData.filter{$0.isChosen == true}
                if returnedChosenFilters.count > 0 {
                    cell.filtersLabel?.text = "(\(returnedChosenFilters.count)) \(returnedChosenFilters.map{$0.filterString}.joined(separator: ", "))"
                    cell.filtersLabel.isHidden = false
                } else {
                    cell.filtersLabel.isHidden = true
                }
            }
        }
        return cell
    }
    
    //MARK: - Prepare Filter Data Before Segue
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if filterStructuresArray[indexPath.row] == nil {
            var filterArray = [Filter]()
            var filterData = [String]()
            var filterType: FilterTypes?
            
            switch indexPath.row {
            case 0:
                products.forEach{filterData.append(contentsOf: $0.details.size)}
                filterType = FilterTypes.size
            case 1:
                products.forEach{filterData.append($0.price.description)}
                filterType = FilterTypes.price
            case 2:
                products.forEach{filterData.append($0.details.gender)}
                filterType = FilterTypes.gender
            case 3:
                products.forEach{filterData.append($0.details.color)}
                filterType = FilterTypes.color
            case 4:
                products.forEach{filterData.append($0.brand.name)}
                filterType = FilterTypes.brand
            default: break
            }
            for string in Array(Set(filterData)) {
                filterArray.append(Filter(filterString: string))
            }
            filterStructure = ProductFilter(filterType: filterType!, filterData: filterArray)
        } else {
            filterStructure = filterStructuresArray[indexPath.row]
        }
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
            let destination = segue.destination as! FilterSecondTableViewController
            destination.filterStructure = filterStructure
            destination.delegate = self
        case "unwindToShopping":
            let destination = segue.destination as! ShoppingViewController
//            destination.filterStructure = ProductFilter(filterType: filterType!, filterData: Array(Set(filterData)))
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

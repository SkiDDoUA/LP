//
//  FilterTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.02.2022.
//

import UIKit

// MARK: - Protocol used for sending data back from FilterTableViewController to ShoppingViewController
protocol FilterDataDelegate: AnyObject {
    func returnFilterData(filterArray: [ProductFilter?], filteredProducts: [UserProduct])
}

class FilterTableViewController: UITableViewController {
    weak var delegate: FilterDataDelegate?
    var products = [UserProduct]()
    var tempProducts = [UserProduct]()
    var selectedIndexPath: IndexPath = IndexPath()
    var barButtonItem = UIBarButtonItem()
    var filterStructure: ProductFilter?
    var filterStructuresArray = [ProductFilter?](repeatElement(nil, count: FilterTypes.allFilters.count)) {
       didSet {
           DispatchQueue.main.async {
               let goodFilters = self.filterStructuresArray.compactMap{$0}
               self.products = self.filterProducts(productsP: self.tempProducts, filters: goodFilters)
           }
       }
    }
    var allProducts = [UserProduct]() {
        didSet {
            products = self.allProducts
            tempProducts = self.allProducts
        }
    }

    // MARK: - Products Filter Function
    public func filterProducts(productsP: [UserProduct], filters: [ProductFilter]) -> [UserProduct] {
        var productFiltered = productsP
        for filterP in filters {
            let chosenFilters = filterP.filterData.filter({$0.isChosen == true})
            if filterP.isUsed {
                switch filterP.filterType {
                case .size:
                    productFiltered.removeAll(where: {!$0.product!.details.sizes.keys.contains(where: chosenFilters.map{$0.filterString}.contains)})
                case .gender:
                    productFiltered.removeAll(where: {!chosenFilters.map{$0.filterString}.contains($0.product!.details.gender)})
                case .color:
                    productFiltered.removeAll(where: {!chosenFilters.map{$0.filterString}.contains($0.product!.details.color)})
                case .brand:
                    productFiltered.removeAll(where: {!chosenFilters.map{$0.filterString}.contains($0.product!.brand.name)})
                default:
                    break
                }
                
                if filterP.filterType == .price {
                    let minAndMax = filterP.priceRange!.components(separatedBy: " - ")
                    let min = Int(Double(minAndMax[0]) ?? 0)
                    let max = Int(Double(minAndMax[1]) ?? 0)
                    productFiltered.removeAll(where: {!(min <= $0.product!.minPrice && $0.product!.minPrice <= max)})
                }
            }
        }
        return productFiltered
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        addResultButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Фильтр"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.returnFilterData(filterArray: filterStructuresArray, filteredProducts: products)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterStructuresArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        if let cell = cell as? FilterTableViewCell {
            cell.filterNameLabel?.text = FilterTypes.allFilters[indexPath.row].details.title
            let currentStructure = filterStructuresArray[indexPath.row]
            if currentStructure != nil {
                let returnedChosenFilters = currentStructure!.filterData.filter{$0.isChosen == true}
                if returnedChosenFilters.count > 0 {
                    if currentStructure?.filterType == .price {
                        let minAndMax = currentStructure?.priceRange!.components(separatedBy: " - ")
                        let min = Int(Double(minAndMax![0]) ?? 0)
                        let max = Int(Double(minAndMax![1]) ?? 0)
                        cell.filtersLabel?.text = "₴\(min) - ₴\(max)"
                        cell.filtersLabel.isHidden = false
                    } else {
                        if returnedChosenFilters.count > 0 {
                            cell.filtersLabel?.text = "(\(returnedChosenFilters.count)) \(returnedChosenFilters.map{$0.filterString}.joined(separator: ", "))"
                            cell.filtersLabel.isHidden = false
                        }
                    }
                } else {
                    cell.filtersLabel.isHidden = true
                }
            } else {
                cell.filtersLabel.isHidden = true
            }
        }
        
        for filter in filterStructuresArray {
            if filter?.isUsed ?? false {
                addClearButton()
                break
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        return cell
    }
    
    //MARK: - Prepare Filter Data Before Segue
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if filterStructuresArray[indexPath.row] == nil || filterStructuresArray[indexPath.row]?.isUsed == false {
            var filterArray = [Filter]()
            var filterData = [String]()
            var filterType: FilterTypes?
            let sizeOrder = ["No size", "One size", "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL", "XXXXL"]

            switch indexPath.row {
            case 0:
                products.forEach{filterData.append(contentsOf: $0.product!.details.sizes.keys)}
                filterType = .size
            case 1:
                products.forEach{filterData.append($0.product!.minPrice.description)}
                filterType = .price
            case 2:
                products.forEach{filterData.append($0.product!.details.gender)}
                filterType = .gender
            case 3:
                products.forEach{filterData.append($0.product!.details.color)}
                filterType = .color
            case 4:
                products.forEach{filterData.append($0.product!.brand.name)}
                filterType = .brand
            default: break
            }
            
            if filterType == .size {
                let stringSizeArray = sizeOrder.filter({Array(Set(filterData)).contains($0)})
                let numberSizeArray = Array(Set(filterData).subtracting(stringSizeArray)).sorted{$0 < $1}
                let sortedSizeArray = stringSizeArray + numberSizeArray
                for string in sortedSizeArray {
                    filterArray.append(Filter(filterString: string))
                }
            } else {
                for string in Array(Set(filterData)) {
                    filterArray.append(Filter(filterString: string))
                }
                filterArray = filterArray.sorted(by: {$0.filterString.lowercased() < $1.filterString.lowercased()})
            }
            if filterType == .price {
                filterStructure = ProductFilter(filterType: filterType!, filterData: filterArray, priceRange: " - ")
            } else {
                filterStructure = ProductFilter(filterType: filterType!, filterData: filterArray)
            }
        } else {
            filterStructure = filterStructuresArray[indexPath.row]
        }
        return indexPath
    }
    
    // MARK: - Clear Chosen Filters
    @IBAction func clearTapped(_ sender: Any) {
        filterStructuresArray = [ProductFilter?](repeatElement(nil, count: FilterTypes.allFilters.count))
        tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
    }
    
    // MARK: - Parse Chosen Filters
    @IBAction func resultTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToShopping", sender: Any?.self)
    }
    
    //MARK: - Parse Filter Data To FilterSecondTableViewController And ShoppingViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toSecondFilter":
            let destination = segue.destination as! FilterSecondTableViewController
            destination.filterStructure = filterStructure
            destination.products = tempProducts
            destination.filterStructuresArray = filterStructuresArray
            destination.delegate = self
        case "unwindToShopping":
            let destination = segue.destination as! ShoppingViewController
            destination.products = products
            destination.filterStructuresArray = filterStructuresArray
        default: break
        }
    }
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
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
    
    public func addClearButton() {
        barButtonItem = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(clearTapped))
        let font = UIFont(name: "Helvetica", size: 14) ?? UIFont()
        let textAttributes: [NSAttributedString.Key: Any] = [.font: font]
        barButtonItem.setTitleTextAttributes(textAttributes, for: .normal)
        barButtonItem.setTitleTextAttributes(textAttributes, for: .selected)
        navigationItem.rightBarButtonItem = barButtonItem
    }
}


// MARK: - SortDataDelegate
extension FilterTableViewController: FilterChosenDelegate {
    func userDidChoseFilters(filter: ProductFilter) {
        filterStructuresArray[filter.filterType.details.index] = filter
        let indexPath = IndexPath(item: filter.filterType.details.index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension String {
    public var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

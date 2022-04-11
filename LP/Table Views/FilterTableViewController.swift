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
               var filteredProducts = [StockProduct]()
               self.tempProducts = self.products
//               let clearFilters: [ProductFilter] = self.filterStructuresArray.compactMap { $0 }
//               for filterP in clearFilters {
//                   print(filteredProducts)
//                   switch filterP.filterType {
//                   case .size:
//                       return filteredProducts = self.tempProducts.filter{$0.details.size.contains(where: filterP.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains)}
////                   case .gender:
////                       return filteredProducts = self.filterP.contains($0.details.gender)
//                   default:
//                       break
//                   }
////                   switch filterP {
////                   case 20...: j = 50
////                   case 15...: j = 70
////                   case 10...: j = 80
////                   case 5...: j = 90
////                   case 0...: j = 100
////                   default: print("out of range")
////                   }
////                   if let j = j { timeAdjustments.append(j) }
//               }
//               print(filteredProducts)
               self.filterStructuresArray.compactMap{$0}.compactMap {filterP in
                   return filteredProducts = self.tempProducts.filter{$0.details.size.contains(where: filterP.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains)}
               }
               print(filteredProducts)
//               self.products = self.tempProducts.filter {
//                   return true
//               }
//               print(self.products)
           }
       }
    }
//               print(self.products)
//               print(self.filterStructuresArray)
//               self.products = self.tempProducts.filter {
//                   var filtered = false
//
//                   if self.filterStructuresArray[0] != nil {
//                       print("00000")
////                       self.filterStructuresArray[0]!.isUsed = true
//                       filtered = $0.details.size.contains(where: self.filterStructuresArray[0]!.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains)
//                       print(filtered)
//                   }
//
//                   if self.filterStructuresArray[2] != nil {
//                       print("22222")
////                       self.filterStructuresArray[2]!.isUsed = true
//                       filtered = ((self.filterStructuresArray[2]?.filterData.map{$0.filterString}.contains($0.details.gender)) != nil)
//                       print(filtered)
//                   }
//
//                   if self.filterStructuresArray[3] != nil {
//                       print("33333")
////                       self.filterStructuresArray[3]!.isUsed = true
//                       filtered = ((self.filterStructuresArray[3]?.filterData.map{$0.filterString}.contains($0.details.color)) != nil)
//                   }
//
//                   if self.filterStructuresArray[4] != nil {
//                       print("44444")
////                       self.filterStructuresArray[4]!.isUsed = true
//                       filtered = ((self.filterStructuresArray[4]?.filterData.map{$0.filterString}.contains($0.brand.name)) != nil)
//                   }
//
//                   return filtered
////                   (Int(self.SSS[1][0]) ?? 0 <= $0.price && $0.price <= Int(self.SSS[1][1]) ?? 0) &&
////                   ((self.filterStructuresArray[2]?.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains($0.details.gender)) != nil) &&
////                   ((self.filterStructuresArray[3]?.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains($0.details.color)) != nil) &&
////                   ((self.filterStructuresArray[4]?.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains($0.brand.name)) != nil)
//               }
//               self.products = self.tempProducts.filter {
//                   var filtered = false
//                   for filter in 0..<self.filterStructuresArray.count {
//                       switch filter {
//                       case 0:
//                           filtered = $0.details.size.contains(where: self.filterStructuresArray[0]!.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains)
//                       case 1:
//                           print("PRICE")
////                           filtered = $0.details.size.contains(where: self.filterStructuresArray[0]!.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains)
//                       case 2:
//                           filtered = ((self.filterStructuresArray[2]?.filterData.map{$0.filterString}.contains($0.details.gender)) != nil)
//                       case 3:
//                           filtered = ((self.filterStructuresArray[3]?.filterData.map{$0.filterString}.contains($0.details.color)) != nil)
//                       default:
//                           filtered = ((self.filterStructuresArray[4]?.filterData.map{$0.filterString}.contains($0.brand.name)) != nil)
//                       }
//                   }
//                   return filtered
                   
//                   if self.filterStructuresArray[0] != nil {
//                       self.filterStructuresArray[0]!.isUsed = true
//                       return $0.details.size.contains(where: self.filterStructuresArray[0]!.filterData.filter{$0.isChosen == true}.map{$0.filterString}.contains)
//                   }
//
//                   if self.filterStructuresArray[2] != nil {
//                       self.filterStructuresArray[2]!.isUsed = true
//                       return ((self.filterStructuresArray[2]?.filterData.map{$0.filterString}.contains($0.details.gender)) != nil)
//                   }
//
//                   if self.filterStructuresArray[3] != nil {
//                       self.filterStructuresArray[3]!.isUsed = true
//                       return ((self.filterStructuresArray[3]?.filterData.map{$0.filterString}.contains($0.details.color)) != nil)
//                   }
//
//                   if self.filterStructuresArray[4] != nil {
//                       self.filterStructuresArray[4]!.isUsed = true
//                       return ((self.filterStructuresArray[4]?.filterData.map{$0.filterString}.contains($0.brand.name)) != nil)
//                   }
//                   return false
//                   (Int(self.SSS[1][0]) ?? 0 <= $0.price && $0.price <= Int(self.SSS[1][1]) ?? 0) &&
//                   ((self.filterStructuresArray[2]?.filterData.map{$0.filterString}.contains($0.details.gender)) != nil) &&
//                   ((self.filterStructuresArray[3]?.filterData.map{$0.filterString}.contains($0.details.color)) != nil) &&
//                   ((self.filterStructuresArray[4]?.filterData.map{$0.filterString}.contains($0.brand.name)) != nil)
//               }

    
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

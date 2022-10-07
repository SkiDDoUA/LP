//
//  FilterSecondTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.03.2022.
//

import UIKit
import RangeSeekSlider

// MARK: - Protocol used for sending data back from FilterSecondTableViewController to FilterTableViewController
protocol FilterChosenDelegate: AnyObject {
    func userDidChoseFilters(filter: ProductFilter)
}

class FilterSecondTableViewController: UITableViewController {
    weak var delegate: FilterChosenDelegate?
    var chosenFilters = [String]()
    var filterStructure: ProductFilter?
    var filterStructuresArray = [ProductFilter?]()
    var products = [UserProduct]()
    var barButtonItem = UIBarButtonItem()
    var minPrice = String()
    var maxPrice = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = " "
        addResultButtonView()
        title = filterStructure?.filterType.details.title
        tableView.register(CustomFilterTableViewCell.nib(), forCellReuseIdentifier: "PriceFilterCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if filterStructure?.isUsed ?? false {
            addClearButton()
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterStructure?.filterType == .price {
            return 1
        } else {
            return (filterStructure?.filterData.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filterStructure?.filterType == .price {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceFilterCell", for: indexPath) as! CustomFilterTableViewCell
            var min = CGFloat()
            var max = CGFloat()
            var priceArray = [String]()
            
            filterStructure?.filterData.forEach{priceArray.append($0.filterString)}
            if filterStructure!.isUsed {
                let minAndMax = filterStructure?.priceRange!.components(separatedBy: " - ")
                min = CGFloat(Double(minAndMax![0]) ?? 0)
                max = CGFloat(Double(minAndMax![1]) ?? 0)
            } else {
                min = CGFloat(Double(priceArray.min()!) ?? 0)
                max = CGFloat(Double(priceArray.max()!) ?? 0)
            }
            
            cell.priceSlider.minValue = CGFloat(Double(priceArray.min()!) ?? 0)
            cell.priceSlider.maxValue = CGFloat(Double(priceArray.max()!) ?? 0)
            cell.priceSlider.selectedMinValue = min
            cell.priceSlider.selectedMaxValue = max
            cell.priceSlider.maxDistance = max
            cell.priceSlider.delegate = self
            tableView.separatorStyle = .none
            tableView.rowHeight = 75.0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSecondCell", for: indexPath)
            if let cell = cell as? FilterSecondTableViewCell {
                cell.filterParameterTextLabel?.text = filterStructure?.filterData[indexPath.row].filterString
                if filterStructure?.filterData[indexPath.row].isChosen == false {
                    cell.checkImageView.isHidden = true
                } else {
                    cell.checkImageView.isHidden = false
                }
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterStructure?.filterType == .price {
            let cell = tableView.cellForRow(at: indexPath) as! CustomFilterTableViewCell
            cell.selectionStyle = .none
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! FilterSecondTableViewCell
            if filterStructure?.filterData[indexPath.row].isChosen == true {
                filterStructure?.filterData[indexPath.row].isChosen = false
                cell.checkImageView.isHidden = true
            } else {
                filterStructure?.filterData[indexPath.row].isChosen = true
                cell.checkImageView.isHidden = false
            }
        }

        if filterStructure?.isUsed ?? false {
            addClearButton()
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let filterType = filterStructure?.filterType
            if filterType == .price {
                let returnFilterStructure = ProductFilter(filterType: filterType!, filterData: filterStructure!.filterData, priceRange: filterStructure!.priceRange)
                delegate?.userDidChoseFilters(filter: returnFilterStructure)
            } else {
                let returnFilterStructure = ProductFilter(filterType: filterType!, filterData: filterStructure!.filterData)
                delegate?.userDidChoseFilters(filter: returnFilterStructure)
            }
        }
    }
    
    // MARK: - Clear Chosen Filters
    @IBAction func clearTapped(_ sender: Any) {
        if filterStructure?.filterType == .price {
            filterStructure!.priceRange = " - "
            filterStructure?.filterData[0].isChosen = false
        } else {
            filterStructure?.filterData.mutateEach {filter in
                filter.isChosen = false
            }
        }
        navigationItem.rightBarButtonItem = nil
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .none)
        tableView.reloadData()
    }
    
    // MARK: - Parse Chosen Filters
    @IBAction func resultTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToShopping", sender: Any?.self)
    }
    
    //MARK: - Parse Chosen Filter Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "unwindToShopping":
            let destination = segue.destination as! ShoppingViewController
            let filterType = filterStructure?.filterType
            if filterType == .price {
                let returnFilterStructure = ProductFilter(filterType: filterType!, filterData: filterStructure!.filterData, priceRange: filterStructure!.priceRange)
                filterStructuresArray[returnFilterStructure.filterType.details.index] = returnFilterStructure
            } else {
                let returnFilterStructure = ProductFilter(filterType: filterType!, filterData: filterStructure!.filterData)
                filterStructuresArray[returnFilterStructure.filterType.details.index] = returnFilterStructure
            }
            let goodFilters = self.filterStructuresArray.compactMap{$0}
            destination.products = FilterTableViewController().filterProducts(productsP: products, filters: goodFilters)
            destination.filterStructuresArray = filterStructuresArray
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
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

extension Array {
    mutating func mutateEach(by transform: (inout Element) throws -> Void) rethrows {
        self = try map { el in
            var el = el
            try transform(&el)
            return el
        }
     }
}

// MARK: - RangeSeekSliderDelegate
extension FilterSecondTableViewController: RangeSeekSliderDelegate {
    public func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        filterStructure!.priceRange = "\(minValue) - \(maxValue)"
        filterStructure?.filterData[0].isChosen = true
        addClearButton()
    }
}

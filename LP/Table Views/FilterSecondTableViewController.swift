//
//  FilterSecondTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.03.2022.
//

import UIKit

// MARK: - Protocol used for sending data back from FilterSecondTableViewController to FilterTableViewController
protocol FilterChosenDelegate: AnyObject {
    func userDidChoseFilters(filter: ProductFilter)
}

class FilterSecondTableViewController: UITableViewController {
    
    var chosenFilters = [String]()
    weak var delegate: FilterChosenDelegate?
    var filterStructure: ProductFilter?
    var filterStructuresArray = [ProductFilter?]()
    var products = [StockProduct]()
    var barButtonItem = UIBarButtonItem()
    var minPrice = String()
    var maxPrice = String()
    
    override func viewWillAppear(_ animated: Bool) {
        print(filterStructure?.filterData)
        if filterStructure?.isUsed ?? false {
            addClearButton()
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        addResultButtonView()
        title = filterStructure?.filterType.details.title
        self.tableView.register(CustomFilterTableViewCell.nib(), forCellReuseIdentifier: "PriceFilterCell")
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
            cell.minPriceTextField.tag = 0
            cell.maxPriceTextField.tag = 1
            cell.minPriceTextField.addTarget(self, action: #selector(self.changeText(sender:)), for: UIControl.Event.editingChanged)
            cell.maxPriceTextField.addTarget(self, action: #selector(self.changeText(sender:)), for: UIControl.Event.editingChanged)
            tableView.separatorStyle = .none
            self.tableView.rowHeight = UITableView.automaticDimension
            configureTapGesture()
            let minAndMax = filterStructure!.filterData[0].filterString.components(separatedBy: " - ")
            if Int(minAndMax[0]) ?? 0 > 0 {
                cell.minPriceTextField.text = minAndMax[0]
            }
            if Int(minAndMax[1]) ?? 0 > 0 {
                cell.maxPriceTextField.text = minAndMax[1]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSecondCell", for: indexPath)
            if let cell = cell as? FilterSecondTableViewCell {
                cell.filterParameterTextLabel?.text = filterStructure?.filterData[indexPath.row].filterString
                if filterStructure?.filterData[indexPath.row].isChosen == true {
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
            if cell.checkImageView.isHidden {
                filterStructure?.filterData[indexPath.row].isChosen = true
                cell.checkImageView.isHidden = false
            }
            else {
                filterStructure?.filterData[indexPath.row].isChosen = false
                cell.checkImageView.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }
        }

        if filterStructure?.isUsed ?? false {
            addClearButton()
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let filterType = filterStructure?.filterType
            let returnFilterStructure = ProductFilter(filterType: filterType!, filterData: filterStructure!.filterData)
            delegate?.userDidChoseFilters(filter: returnFilterStructure)
        }
    }
    
    // MARK: - Clear Chosen Filters
    @IBAction func clearTapped(_ sender: Any) {
        if filterStructure?.filterType == .price {
            filterStructure!.filterData[0].filterString = " - "
            filterStructure?.filterData[0].isChosen = false
        } else {
            filterStructure?.filterData.mutateEach {filter in
                filter.isChosen = false
            }
        }
        self.navigationItem.rightBarButtonItem = nil
        tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none) // FIX
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
            let returnFilterStructure = ProductFilter(filterType: filterType!, filterData: filterStructure!.filterData)
            filterStructuresArray[returnFilterStructure.filterType.details.index] = returnFilterStructure
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
    
    // MARK: TextField Input Handler
    @objc func changeText(sender: UITextField) {
        if sender.tag == 0 {
            minPrice = sender.text!
        } else {
            maxPrice = sender.text!
        }
        filterStructure!.filterData[0].filterString = "\(minPrice) - \(maxPrice)"
        filterStructure?.filterData[0].isChosen = true
        addClearButton()
    }
    
    // MARK: TapGesture
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FilterSecondTableViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
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

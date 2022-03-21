//
//  SizechartTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 08.02.2022.
//

import UIKit

class SizeChartTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var defaultSizeLabel: UILabel!
    @IBOutlet weak var sizeTextField: СustomUITextField!
    @IBOutlet weak var dataSizeTableView: UITableView!
    @IBOutlet weak var sizeChartTableViewConstraint: NSLayoutConstraint!
    
    var viewPicker = UIPickerView()
    var productType = String()
    var productBrand = String()
    var sizechartKeys = [String]()
    var oddSizechartKey = String()
    var currentSizechartArray = [String]()
    var maxLengthSizechart = [Int]()
    var counter = 0
    var standart = "Стандарт"
    var sizechart: Sizechart! {
       didSet {
           DispatchQueue.main.async {
               self.dataSizeTableView.reloadData()
           }
       }
    }

    static func nib() -> UINib {
        return UINib(nibName: "SizeChartTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sizeTextField.text = standart
                        
        self.dataSizeTableView.delegate = self
        self.dataSizeTableView.dataSource = self
        dataSizeTableView.layoutIfNeeded()
        sizeChartTableViewConstraint.constant = dataSizeTableView.contentSize.height
        
        viewPicker.dataSource = self
        viewPicker.delegate = self
        viewPicker.backgroundColor = UIColor.systemBackground
        sizeTextField.inputView = viewPicker
        sizeTextField.setEditActions(only: [])
        self.sizeTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
        
        dataSizeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SizeChartTableViewCell")
        dataSizeTableView.register(UINib(nibName: "TwoColumnsTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoColumnsTableViewCell")
    }
    
    // MARK: - PickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if sizechart.toDictionary!.count <= 2 {
            return sizechart.toDictionary?.count ?? 0
        }
        return sizechart.toDictionary!.count - 1
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if sizechartKeys[row] == "Default" {
            return standart
        } else {
            return sizechartKeys[row]
        }
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sizechartKeys[row] == "Default" {
            sizeTextField.text = standart
        } else {
            sizeTextField.text = sizechartKeys[row]
        }
    }
    
    // MARK: - TableView Delegation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sizechart.toDictionary?.forEach({ (key: String, value: Any?) in
            sizechartKeys.append(key)
            maxLengthSizechart.append((value as! NSArray as? [String])!.count)
//            print(value)
        })
        sizechartKeys.removeAll(where: { $0 == oddSizechartKey })
//        print(maxLengthSizechart)
        let ss = Int(maxLengthSizechart.max() ?? 0)
//        print(ss)
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoColumnsTableViewCell", for: indexPath)
        if let cell = cell as? TwoColumnsTableViewCell {
            switch productType {
            case "ring":
                cell.firstSizeLabel?.text = sizechart.EU?[optional: indexPath.row] ?? "—"
                if counter == 0 {
                    cell.secondSizeLabel?.text = sizechart.Default?[optional: indexPath.row] ?? "—"
                } else {
                    cell.secondSizeLabel?.text = currentSizechartArray[optional: indexPath.row] ?? "—"
                }
                defaultSizeLabel.text = "EU к:"
                oddSizechartKey = "EU"
            case "belt":
                cell.firstSizeLabel?.text = sizechart.CM?[optional: indexPath.row] ?? "—"
                if counter == 0 {
                    cell.secondSizeLabel?.text = sizechart.Default?[optional: indexPath.row] ?? "—"
                } else {
                    cell.secondSizeLabel?.text = currentSizechartArray[optional: indexPath.row] ?? "—"
                }
                defaultSizeLabel.text = "CM к:"
                oddSizechartKey = "CM"
            default:
                if productBrand == "Moncler" {
                    cell.firstSizeLabel?.text = sizechart.Moncler?[optional: indexPath.row] ?? "—"
                    if counter == 0 {
                        cell.secondSizeLabel?.text = sizechart.Default?[optional: indexPath.row] ?? "—"
                    } else {
                        cell.secondSizeLabel?.text = currentSizechartArray[optional: indexPath.row] ?? "—"
                    }
                    defaultSizeLabel.text = "Moncler к:"
                    oddSizechartKey = "Moncler"
                } else {
                    cell.firstSizeLabel?.text = sizechart.IT?[optional: indexPath.row] ?? "—"
                    if counter == 0 {
                        cell.secondSizeLabel?.text = sizechart.US?[optional: indexPath.row] ?? "—"
                        sizeTextField.text = "US"
                    } else {
                        cell.secondSizeLabel?.text = currentSizechartArray[optional: indexPath.row] ?? "—"
                    }
                    oddSizechartKey = "IT"
                }
            }
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(named: "Light GreyLP")
            }
        }
        return cell
    }
    
    // MARK: - Set ViewPicker
    @objc func tapDoneViewPicker() {
        if sizeTextField.text == standart {
            currentSizechartArray = (sizechart.toDictionary?["Default"])! as! [String]
        } else {
            currentSizechartArray = (sizechart.toDictionary?[sizeTextField.text!])! as! [String]
        }
        counter = 1
        self.dataSizeTableView.reloadData()
        self.sizeTextField.resignFirstResponder()
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (optional index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

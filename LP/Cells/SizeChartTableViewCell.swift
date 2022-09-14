//
//  SizechartTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 08.02.2022.
//

import UIKit

class SizeChartTableViewCell: UITableViewCell {
    @IBOutlet weak var defaultSizeLabel: UILabel!
    @IBOutlet weak var sizeTextField: СustomUITextField!
    @IBOutlet weak var dataSizeTableView: UITableView!
    @IBOutlet weak var sizeChartTableViewConstraint: NSLayoutConstraint!
    
    var maxLengthSizechart = ProductViewController.maxLengthSizechartToCell
    var sizechartKeys = ProductViewController.sizechartKeysToCell
    var pickerSizechartKeys = [String]()
    var viewPicker = UIPickerView()
    var productType = String()
    var productBrand = String()
    var currentSizechartArray = [String]()
    var counter = 0
    var standart = "Стандарт"
    var sizechart: Sizechart!

    static func nib() -> UINib {
        return UINib(nibName: "SizeChartTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dataSizeTableView.delegate = self
        dataSizeTableView.dataSource = self
        dataSizeTableView.layoutIfNeeded()
        sizeChartTableViewConstraint.constant = dataSizeTableView.contentSize.height
        
        viewPicker.dataSource = self
        viewPicker.delegate = self
        viewPicker.backgroundColor = UIColor.systemBackground
        
        sizeTextField.text = standart
        sizeTextField.inputView = viewPicker
        sizeTextField.setEditActions(only: [])
        sizeTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
        
        dataSizeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SizeChartTableViewCell")
        dataSizeTableView.register(UINib(nibName: "TwoColumnsTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoColumnsTableViewCell")
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

// MARK: - UITableViewDelegate
extension SizeChartTableViewCell: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxLengthSizechart
    }
}
    
// MARK: - UITableViewDataSource
extension SizeChartTableViewCell: UITableViewDataSource {
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
                pickerSizechartKeys = sizechartKeys.filter(){$0 != "EU"}
            case "belt":
                cell.firstSizeLabel?.text = sizechart.CM?[optional: indexPath.row] ?? "—"
                if counter == 0 {
                    cell.secondSizeLabel?.text = sizechart.Default?[optional: indexPath.row] ?? "—"
                } else {
                    cell.secondSizeLabel?.text = currentSizechartArray[optional: indexPath.row] ?? "—"
                }
                defaultSizeLabel.text = "CM к:"
                pickerSizechartKeys = sizechartKeys.filter(){$0 != "CM"}
            default:
                if productBrand == "Moncler" {
                    cell.firstSizeLabel?.text = sizechart.Moncler?[optional: indexPath.row] ?? "—"
                    if counter == 0 {
                        cell.secondSizeLabel?.text = sizechart.Default?[optional: indexPath.row] ?? "—"
                    } else {
                        cell.secondSizeLabel?.text = currentSizechartArray[optional: indexPath.row] ?? "—"
                    }
                    defaultSizeLabel.text = "Moncler к:"
                    pickerSizechartKeys = sizechartKeys.filter(){$0 != "Moncler"}
                } else {
                    cell.firstSizeLabel?.text = sizechart.IT?[optional: indexPath.row] ?? "—"
                    if counter == 0 {
                        cell.secondSizeLabel?.text = sizechart.US?[optional: indexPath.row] ?? "—"
                        sizeTextField.text = "US"
                    } else {
                        cell.secondSizeLabel?.text = currentSizechartArray[optional: indexPath.row] ?? "—"
                    }
                    pickerSizechartKeys = sizechartKeys.filter(){$0 != "IT"}
                }
            }
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(named: "Light GreyLP")
        } else {
            cell.backgroundColor = UIColor(named: "WhiteLP")
        }
        return cell
    }
}
    
// MARK: - UIPickerViewDelegate
extension SizeChartTableViewCell: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if sizechart.toDictionary!.count <= 2 {
            return sizechart.toDictionary?.count ?? 0
        }
        return sizechart.toDictionary!.count - 1
    }
}

// MARK: - UIPickerViewDataSource
extension SizeChartTableViewCell: UIPickerViewDataSource {
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerSizechartKeys[row] == "Default" {
            return standart
        } else {
            return pickerSizechartKeys[row]
        }
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerSizechartKeys[row] == "Default" {
            sizeTextField.text = standart
        } else {
            sizeTextField.text = pickerSizechartKeys[row]
        }
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (optional index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

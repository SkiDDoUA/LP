//
//  CartProductTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 26.07.2022.
//

import UIKit

class CartProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var sizePickerTextField: СustomUITextField!
    @IBOutlet weak var quantitytPickerTextField: СustomUITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    var viewPickerSize = UIPickerView()
    var viewPickerQuantity = UIPickerView()
    var sizeKeys = [String : Int]()
    var sortedKeys = [String]()
    var pickerKeys = [String]()
    
    func configure(for product: Product, size: String) {
        self.productBrandLabel.text = product.brand.name.uppercased()
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "₴\(product.price.description)"
        self.productImageView.kf.setImage(with: URL(string: product.images[0]))
        self.sizeKeys = product.details.size
        self.pickerKeys = [String](sizeKeys.keys)
        
        if pickerKeys.contains(size) {
            sizePickerTextField.text = size
        }
        viewPickerSize.dataSource = self
        viewPickerSize.delegate = self
        viewPickerSize.backgroundColor = UIColor.systemBackground
        viewPickerSize.tag = 0
        sizePickerTextField.inputView = viewPickerSize
        viewPickerQuantity.dataSource = self
        viewPickerQuantity.delegate = self
        viewPickerQuantity.backgroundColor = UIColor.systemBackground
        viewPickerQuantity.tag = 1
        quantitytPickerTextField.inputView = viewPickerQuantity
        sizePickerTextField.setEditActions(only: [])
        self.sizePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
        quantitytPickerTextField.setEditActions(only: [])
        self.quantitytPickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
    }
    
    // MARK: - Set ViewPicker
    @objc func tapDoneViewPicker() {
        self.sizePickerTextField.resignFirstResponder()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CartProductTableViewCell: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension CartProductTableViewCell: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView.tag == 0 {
//            return sizeKeys.count
//        } else {
//            return skillNeeded[row]
//        }
        return sizeKeys.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let sizeOrder = ["One size", "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL", "XXXXL"]
        sortedKeys = sizeOrder.filter({pickerKeys.contains($0)})
        return sortedKeys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(sizeKeys.values)
        sizePickerTextField.text = sortedKeys[row]
    }
}

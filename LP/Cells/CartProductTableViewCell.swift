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
    var sortedKeys = [String]()
    var pickerKeys = [String]()
    var sizeValues = [Int]()
    var sizeQuantity = [Int]()
    var choosenSizeRow = Int()
    var cartProduct: UserProduct!
    
    func configure(for cartProduct: UserProduct) {
        self.cartProduct = cartProduct
        self.productBrandLabel.text = cartProduct.product!.brand.name.uppercased()
        self.productNameLabel.text = cartProduct.product!.name
        self.productPriceLabel.text = "₴\(cartProduct.product!.price.description)"
        self.productImageView.kf.setImage(with: URL(string: cartProduct.product!.images[0]))
        self.pickerKeys = [String](cartProduct.product!.details.size.keys)
        self.sizeValues = [Int](cartProduct.product!.details.size.values)
        
        if pickerKeys.contains(cartProduct.size!) {
            sizePickerTextField.text = cartProduct.size
        }
        
        viewPickerSize.selectRow(0, inComponent: 0, animated: true)
        viewPickerSize.dataSource = self
        viewPickerSize.delegate = self
        viewPickerQuantity.dataSource = self
        viewPickerQuantity.delegate = self
        viewPickerSize.backgroundColor = UIColor.systemBackground
        viewPickerQuantity.backgroundColor = UIColor.systemBackground
        viewPickerSize.tag = 0
        viewPickerQuantity.tag = 1
        sizePickerTextField.text = cartProduct.size
        quantitytPickerTextField.text = "1"
        sizePickerTextField.inputView = viewPickerSize
        quantitytPickerTextField.inputView = viewPickerQuantity
        sizePickerTextField.setEditActions(only: [])
        self.sizePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPickerSize))
        quantitytPickerTextField.setEditActions(only: [])
        self.quantitytPickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPickerQuantity))
    }
    
    // MARK: - Set ViewPicker
    @objc func tapDoneViewPickerSize() {
        self.sizePickerTextField.resignFirstResponder()
    }
    
    @objc func tapDoneViewPickerQuantity() {
        self.quantitytPickerTextField.resignFirstResponder()
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
        if pickerView.tag == 0 {
            return cartProduct.product!.details.size.count
        } else {
            sizeQuantity = Array(1...sizeValues[choosenSizeRow])
            return sizeQuantity.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            let sizeOrder = ["No size", "One size", "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL", "XXXXL"]
            let stringSizeArray = sizeOrder.filter({pickerKeys.contains($0)})
            let numberSizeArray = Array(Set(pickerKeys).subtracting(stringSizeArray)).sorted{$0 < $1}
            sortedKeys = stringSizeArray + numberSizeArray
            return sortedKeys[row]
        } else {
            return String(sizeQuantity[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            sizePickerTextField.text = sortedKeys[row]
            quantitytPickerTextField.text = "1"
            viewPickerQuantity.selectRow(0, inComponent: 0, animated: true)
            choosenSizeRow = pickerKeys.firstIndex(where: {$0 == sortedKeys[row]})!
        } else {
            quantitytPickerTextField.text = String(sizeQuantity[row])
        }
    }
}

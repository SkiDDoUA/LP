//
//  CartProductTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 26.07.2022.
//

import UIKit

class CartProductTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var sizePickerTextField: СustomUITextField!
    @IBOutlet weak var quantityPickerTextField: СustomUITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    private var database = Database()
    var viewPickerSize = UIPickerView()
    var viewPickerQuantity = UIPickerView()
    var sizeQuantity = [Int]()
    var sizeRow = Int()
    var product: UserProduct!
    
    func configure(for cartProduct: UserProduct) {
        self.product = cartProduct
        self.productBrandLabel.text = cartProduct.product!.brand.name.uppercased()
        self.productNameLabel.text = cartProduct.product!.name
        self.productPriceLabel.text = "₴\(cartProduct.product!.minPrice.description)"
        self.productImageView.kf.setImage(with: URL(string: cartProduct.product!.images[0]))

        if cartProduct.product!.details.sizeKeys.contains(cartProduct.size!) {
            sizePickerTextField.text = cartProduct.size
            sizeRow = cartProduct.product!.details.sortedSizes.firstIndex(where: { $0.size == cartProduct.size! }) ?? 0
        }
        
        quantityPickerTextField.delegate = self
        quantityPickerTextField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: .editingChanged)

        
        viewPickerSize.dataSource = self
        viewPickerSize.delegate = self
        viewPickerQuantity.dataSource = self
        viewPickerQuantity.delegate = self
        viewPickerSize.backgroundColor = UIColor.systemBackground
        viewPickerQuantity.backgroundColor = UIColor.systemBackground
        viewPickerSize.tag = 0
        viewPickerQuantity.tag = 1
        sizePickerTextField.text = cartProduct.size
        sizePickerTextField.inputView = viewPickerSize
        quantityPickerTextField.inputView = viewPickerQuantity
        sizePickerTextField.setEditActions(only: [])
        quantityPickerTextField.setEditActions(only: [])
        
        self.sizePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPickerSize))
        self.quantityPickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPickerQuantity))
        
        viewPickerSize.selectRow(sizeRow, inComponent: 0, animated: true)
        viewPickerQuantity.selectRow(cartProduct.quantity!-1, inComponent: 0, animated: true)
        quantityPickerTextField.text = String(cartProduct.quantity!)
    }
    
    @IBAction func sizeTextFieldDidEndEditing(_ sender: Any) {
        let size = sizePickerTextField.text
        database.editUserProductCart(cartProduct: product, size: size!)
    }
    
    @IBAction func dsds(_ sender: Any) {
        print("TEEEEEST")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TEEEEEST")
// do stuff
            return true
    }
//    func textField(_ textField: UITextField, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {
//        print("TEEEEEST2222")
//
//    }

    //    @IBAction func quantityTextFieldDidEndEditing(_ sender: Any) {
//        let quantity = Int(quantityPickerTextField.text!)
//        database.editUserProductCart(cartProduct: product, quantity: quantity)
//    }
    
    // MARK: - Set ViewPicker
    @objc func tapDoneViewPickerSize() {
        self.sizePickerTextField.resignFirstResponder()
    }
    
    @objc func tapDoneViewPickerQuantity() {
        self.quantityPickerTextField.resignFirstResponder()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
            return product.product!.details.sizes.count
        } else {
            let sizeValue = product.product!.details.sortedSizes[sizeRow].quantity
            sizeQuantity = Array(1...sizeValue)
            return sizeQuantity.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return product.product!.details.sortedSizes[row].size
        } else {
            return String(sizeQuantity[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            let size = product.product!.details.sortedSizes[row].size
            sizePickerTextField.text = size
            sizeRow = row
            quantityPickerTextField.text = "1"
//            database.editUserProductCart(cartProduct: product, size: size, quantity: 1)
        } else {
//            let size = product.product!.details.sortedSizes[row].size
//            let quantity = sizeQuantity[row]
            quantityPickerTextField.text = String(sizeQuantity[row])
//            database.editUserProductCart(cartProduct: product, size: size, quantity: quantity)
        }
    }
}

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
    @IBOutlet weak var quantityPickerTextField: СustomUITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    private var database = Database()
    var viewPickerSize = UIPickerView()
    var viewPickerQuantity = UIPickerView()
    var sortedKeys = [String]()
    var sizeValue = Int()
    var sizeQuantity = [Int]()
    var choosenSize = String()
    var productSizes = [String: ProductSize]()
    var cartProduct: UserProduct!
    var reloadQuantity = Bool()
    
    func configure(for cartProduct: UserProduct) {
        self.cartProduct = cartProduct
        self.productBrandLabel.text = cartProduct.product!.brand.name.uppercased()
        self.productNameLabel.text = cartProduct.product!.name
        self.productPriceLabel.text = "₴\(cartProduct.product!.minPrice.description)"
        self.productImageView.kf.setImage(with: URL(string: cartProduct.product!.images[0]))
        self.productSizes = cartProduct.product!.details.sizes
        
        if productSizes.keys.contains(cartProduct.size!) {
            sizePickerTextField.text = cartProduct.size
            choosenSize = cartProduct.size!
        }

        let sizeOrder = ["No size", "One size", "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL", "XXXXL"]
        let stringSizeArray = sizeOrder.filter({productSizes.keys.contains($0)})
        let numberSizeArray = Array(Set(productSizes.keys).subtracting(stringSizeArray)).sorted{$0 < $1}
        sortedKeys = stringSizeArray + numberSizeArray
        sizeValue = sortedKeys.firstIndex(of: choosenSize)!

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
        self.sizePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPickerSize))
        quantityPickerTextField.setEditActions(only: [])
        self.quantityPickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPickerQuantity))
        viewPickerSize.selectRow(sizeValue, inComponent: 0, animated: true)
        quantityPickerTextField.text = String(cartProduct.quantity!)
        viewPickerQuantity.selectRow(cartProduct.quantity!-1, inComponent: 0, animated: true)
    }

    @IBAction func sizeTextFieldDidEndEditing(_ sender: Any) {
        let size = sizePickerTextField.text
        database.editUserProductCart(cartProduct: cartProduct, size: size!)
    }
    
    @IBAction func quantityTextFieldDidEndEditing(_ sender: Any) {
        let quantity = Int(quantityPickerTextField.text!) ?? 1
        let size = sizePickerTextField.text
        database.editUserProductCart(cartProduct: cartProduct, size: size!, quantity: quantity)
    }
    
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
            return cartProduct.product!.details.sizes.count
        } else {
            let sizeValue = productSizes[choosenSize]!.quantity
            sizeQuantity = Array(1...sizeValue)
            return sizeQuantity.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return sortedKeys[row]
        } else {
            return String(sizeQuantity[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            sizePickerTextField.text = sortedKeys[row]
            choosenSize = sortedKeys[row]
            quantityPickerTextField.text = "1"
            database.editUserProductCart(cartProduct: cartProduct, size: choosenSize, quantity: 1)
        } else {
            quantityPickerTextField.text = String(sizeQuantity[row])
        }
    }
}

//
//  FavoriteProductTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 11.06.2022.
//

import UIKit

class FavoriteProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var sizePickerTextField: СustomUITextField!
    @IBOutlet weak var addToBagButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    
    var viewPicker = UIPickerView()
    var sizeKeys = [String : Int]()
    
    func configure(for product: Product) {
        self.productBrandLabel.text = product.brand.name.uppercased()
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "₴\(product.price.description)"
        self.productImageView.kf.setImage(with: URL(string: product.images[0]))
        self.sizeKeys = product.details.size
        
        viewPicker.dataSource = self
        viewPicker.delegate = self
        viewPicker.backgroundColor = UIColor.systemBackground
        sizePickerTextField.inputView = viewPicker
        sizePickerTextField.setEditActions(only: [])
        self.sizePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
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

extension FavoriteProductTableViewCell: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension FavoriteProductTableViewCell: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeKeys.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerKeys = [String](sizeKeys.keys)
        return pickerKeys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerKeys = [String](sizeKeys.keys)
        sizePickerTextField.text = pickerKeys[row]
    }
}

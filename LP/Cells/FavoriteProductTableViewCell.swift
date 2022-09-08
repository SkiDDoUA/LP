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
    @IBOutlet weak var detailsConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    private var database: Database?
    var viewPicker = UIPickerView()
    var sizeKeys = [String : Int]()
    var sortedKeys = [String]()
    var pickerKeys = [String]()
    var product: UserProduct!
    
    func configure(for favoriteProduct: UserProduct) {
        self.product = favoriteProduct
        self.productBrandLabel.text = favoriteProduct.product!.brand.name.uppercased()
        self.productNameLabel.text = favoriteProduct.product!.name
        self.productPriceLabel.text = "₴\(favoriteProduct.product!.price.description)"
        self.productImageView.kf.setImage(with: URL(string: favoriteProduct.product!.images[0]))
        self.sizeKeys = favoriteProduct.product!.details.size
        self.pickerKeys = [String](sizeKeys.keys)
        
        if pickerKeys.contains(favoriteProduct.size!) {
            sizePickerTextField.text = favoriteProduct.size
        } else {
            addToBagButton.isHidden = true
            detailsConstraint.constant = 55
            stackViewHeight.constant = 95
        }
        
        viewPicker.dataSource = self
        viewPicker.delegate = self
        viewPicker.backgroundColor = UIColor.systemBackground
        sizePickerTextField.inputView = viewPicker
        sizePickerTextField.setEditActions(only: [])
        self.sizePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
    }
    
    //MARK: - Add To Cart
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        let size = sizePickerTextField.text
        if size != "" {
            database = Database()
            database?.addUserProduct(collection: .cart, productReference: product.product!.reference, size: size)
        }
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
        let sizeOrder = ["No size", "One size", "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL", "XXXXL"]
        let stringSizeArray = sizeOrder.filter({pickerKeys.contains($0)})
        let numberSizeArray = Array(Set(pickerKeys).subtracting(stringSizeArray)).sorted{$0 < $1}
        sortedKeys = stringSizeArray + numberSizeArray
        return sortedKeys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sizePickerTextField.text = sortedKeys[row]
        addToBagButton.isHidden = false
        detailsConstraint.constant = 15
        stackViewHeight.constant = 135
    }
}

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
    @IBOutlet weak var sizeTextField: СustomUITextField!
    @IBOutlet weak var amountTextField: СustomUITextField!
    @IBOutlet weak var addToBagButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    
    func configure(for product: Product) {
        self.productBrandLabel.text = product.brand.name.uppercased()
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "₴\(product.price.description)"
        self.productImageView.kf.setImage(with: URL(string: product.images[0]))
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

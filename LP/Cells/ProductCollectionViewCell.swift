//
//  ProductCollectionViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 01.01.2022.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    
    func configure(for product: Product) {
        self.productBrandLabel.text = product.brand.name.uppercased()
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "₴\(product.price.description)"
        self.productImageView.kf.setImage(with: URL(string: product.images[0]))
    }
}

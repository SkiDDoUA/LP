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
    
    private var database: Database?
    var product: Product!
    var favoriteButtonChoosen = false
    
    func configure(for product: Product) {
        self.product = product
        self.productBrandLabel.text = product.brand.name.uppercased()
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "₴\(product.price.description)"
        self.productImageView.kf.setImage(with: URL(string: product.images[0]))
    }
    
    //MARK: - Add To Favorite
    @IBAction func addToFavoriteButtonTapped(_ sender: Any) {
        database = Database()
        favoriteButtonChoosen = !favoriteButtonChoosen

        if favoriteButtonChoosen == true {
            database?.addUserProduct(collection: .favorites, productReference: product.reference, size: "")
            favoriteButton.setImage(UIImage(named: "Favorite Filled"), for: .normal)
        } else {
            database?.removeUserProduct(collection: .favorites, productReference: product.reference)
            favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
        }
    }
}

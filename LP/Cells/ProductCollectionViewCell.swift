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
    
    private var database = Database()
    var userProduct: UserProduct!
    var counter = 0
    
    func configure(for product: UserProduct) {
        DispatchQueue.main.async {
            self.productBrandLabel.text = product.product!.brand.name.uppercased()
            self.productNameLabel.text = product.product!.name
            self.productPriceLabel.text = "₴\(product.product!.price.description)"
            self.productImageView.kf.setImage(with: URL(string: product.product!.images[0]))
            self.userProduct = product
        
            if self.userProduct.isFavorite == true {
                self.favoriteButton.setImage(UIImage(named: "Favorite Filled"), for: .normal)
            } else {
                self.favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
            }
        }
    }
    
    //MARK: - Add To Favorite
    @IBAction func addToFavoriteButtonTapped(_ sender: Any) {
        if !userProduct.isFavorite! == true {
            database.addUserProduct(collection: .favorites, productReference: userProduct.product!.reference, size: "")
        } else {
            database.removeUserProduct(collection: .favorites, productReference: userProduct.product!.reference)
        }
    }
}

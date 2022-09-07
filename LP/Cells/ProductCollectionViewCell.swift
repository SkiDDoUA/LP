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
    var userProduct: UserProduct!
    var counter = 0
    
    func configure(for product: UserProduct) {
        self.productBrandLabel.text = product.product!.brand.name.uppercased()
        self.productNameLabel.text = product.product!.name
        self.productPriceLabel.text = "₴\(product.product!.price.description)"
        self.productImageView.kf.setImage(with: URL(string: product.product!.images[0]))
        self.userProduct = product

        if userProduct.isFavorite == true {
            favoriteButton.setImage(UIImage(named: "Favorite Filled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
        }
        print("product: \(product.product?.brand.name) + \(product.isFavorite)")

//        if userProduct == nil {
//            self.userProduct = product
//            print(product.isFavorite)
//
//            if product.isFavorite == true {
//                favoriteButton.setImage(UIImage(named: "Favorite Filled"), for: .normal)
//            } else {
//                favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
//            }
////
////            print("product: \(product.product?.brand.name) + \(product.isFavorite)")
////            print("userProduct: \(userProduct.product?.brand.name) + \(userProduct.isFavorite)")
//        } else {
//            print(userProduct.isFavorite)
//            if userProduct.isFavorite == true {
//                favoriteButton.setImage(UIImage(named: "Favorite Filled"), for: .normal)
//            } else {
//                favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
//            }
//        }
//        print("product: \(product.product?.brand.name) + \(product.isFavorite)")
//        print("userProduct: \(userProduct.product?.brand.name) + \(userProduct.isFavorite)")
//        if counter == 0 {
//            print(userProduct.isFavorite)
//            if userProduct.isFavorite == true {
//                favoriteButton.setImage(UIImage(named: "Favorite Filled"), for: .normal)
//            } else {
//                favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
//            }
//        }
//        counter += 1
    }
    
    //MARK: - Add To Favorite
    @IBAction func addToFavoriteButtonTapped(_ sender: Any) {
        database = Database()
        print(!userProduct.isFavorite!)
        if !userProduct.isFavorite! == true {
            userProduct.isFavorite = true
            favoriteButton.setImage(UIImage(named: "Favorite Filled"), for: .normal)
            database?.addUserProduct(collection: .favorites, productReference: userProduct.product!.reference, size: "")
        } else {
            userProduct.isFavorite = false
            favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
            database?.removeUserProduct(collection: .favorites, productReference: userProduct.product!.reference)
        }
    }
}

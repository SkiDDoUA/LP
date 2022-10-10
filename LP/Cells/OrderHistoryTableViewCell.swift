//
//  OrderProductTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 21.08.2022.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderItemOneImageView: UIImageView!
    @IBOutlet weak var orderItemTwoImageView: UIImageView!
    @IBOutlet weak var orderItemThreeImageView: UIImageView!
    
    func configure(for orderProduct: Order) {
        orderStatusLabel.text = orderProduct.status.statusString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        orderDateLabel.text = dateFormatter.string(from: orderProduct.createdAt)
        
        let productsAmount = orderProduct.products.count
        for (index, productUnit) in orderProduct.products.enumerated() {
            switch index{
            case 0:
                orderItemOneImageView.kf.setImage(with: URL(string: productUnit.product!.images[0]))
            case 1:
                orderItemTwoImageView.kf.setImage(with: URL(string: productUnit.product!.images[0]))
            case 2:
                orderItemThreeImageView.kf.setImage(with: URL(string: productUnit.product!.images[0]))
                
                if productsAmount > 3 {
                    let greyOverlayView = UIView()
                    greyOverlayView.frame = orderItemThreeImageView.bounds
                    greyOverlayView.layer.compositingFilter = "multiplyBlendMode"
                    greyOverlayView.backgroundColor = .darkGray
                    orderItemThreeImageView.addSubview(greyOverlayView)
                    productAmountLabel.text = "+\(productsAmount-3)"
                    productAmountLabel.isHidden = false
                }
            default:
                return
            }
        }
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

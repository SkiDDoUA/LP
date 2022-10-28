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
        if productsAmount <= 3 {
            if let viewWithTag = orderItemThreeImageView.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
            productAmountLabel.isHidden = true
        }
        
        switch productsAmount {
        case 1:
            orderItemOneImageView.kf.setImage(with: URL(string: orderProduct.products[0].product!.images[0]))
            orderItemTwoImageView.isHidden = true
            orderItemThreeImageView.isHidden = true
        case 2:
            orderItemOneImageView.kf.setImage(with: URL(string: orderProduct.products[0].product!.images[0]))
            orderItemTwoImageView.kf.setImage(with: URL(string: orderProduct.products[1].product!.images[0]))
            orderItemTwoImageView.isHidden = false
            orderItemThreeImageView.isHidden = true
        case 3:
            orderItemOneImageView.kf.setImage(with: URL(string: orderProduct.products[0].product!.images[0]))
            orderItemTwoImageView.kf.setImage(with: URL(string: orderProduct.products[1].product!.images[0]))
            orderItemThreeImageView.kf.setImage(with: URL(string: orderProduct.products[2].product!.images[0]))
            orderItemTwoImageView.isHidden = false
            orderItemThreeImageView.isHidden = false
        default:
            orderItemOneImageView.kf.setImage(with: URL(string: orderProduct.products[0].product!.images[0]))
            orderItemTwoImageView.kf.setImage(with: URL(string: orderProduct.products[1].product!.images[0]))
            orderItemThreeImageView.kf.setImage(with: URL(string: orderProduct.products[2].product!.images[0]))
            orderItemTwoImageView.isHidden = false
            orderItemThreeImageView.isHidden = false

            if productAmountLabel.isHidden == true {
                let greyOverlayView = UIView()
                greyOverlayView.frame = orderItemThreeImageView.bounds
                greyOverlayView.layer.compositingFilter = "multiplyBlendMode"
                greyOverlayView.backgroundColor = .darkGray
                greyOverlayView.tag = 100
                orderItemThreeImageView.addSubview(greyOverlayView)
                productAmountLabel.text = "+\(productsAmount-3)"
                productAmountLabel.isHidden = false
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

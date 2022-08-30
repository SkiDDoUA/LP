//
//  OrderProductTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 21.08.2022.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderItemOneImageView: UIImageView!
    @IBOutlet weak var orderItemTwoImageView: UIImageView!
    @IBOutlet weak var orderItemThreeImageView: UIImageView!
    
    func configure(for orderProduct: Order) {
        self.orderStatusLabel.text = orderProduct.status.statusString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.orderDateLabel.text = dateFormatter.string(from: orderProduct.createdAt)
        
        for (index, productUnit) in orderProduct.products.enumerated() {
            print(index)
            switch index{
            case 0:
                self.orderItemOneImageView.kf.setImage(with: URL(string: productUnit.product!.images[0]))
            case 1:
                self.orderItemTwoImageView.kf.setImage(with: URL(string: productUnit.product!.images[0]))
            case 2:
                self.orderItemThreeImageView.kf.setImage(with: URL(string: productUnit.product!.images[0]))
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

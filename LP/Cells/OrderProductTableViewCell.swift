//
//  OrderProductTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 21.08.2022.
//

import UIKit

class OrderProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sizeLabelWidthConstraint: NSLayoutConstraint!
    
    func configure(for orderProduct: UserProduct) {
        self.productBrandLabel.text = orderProduct.product!.brand.name.uppercased()
        self.productNameLabel.text = orderProduct.product!.name
        self.productPriceLabel.text = "₴\(orderProduct.product!.price.description)"
        self.productImageView.kf.setImage(with: URL(string: orderProduct.product!.images[0]))
        
        self.quantityLabel.text = orderProduct.quantity?.description
        self.quantityLabel.layer.borderWidth = 1.0
        self.quantityLabel.layer.borderColor = UIColor(named: "BlackLP")?.cgColor
        self.quantityLabelWidthConstraint.constant =  self.quantityLabel.intrinsicContentSize.width + 18.0
        
        self.sizeLabel.text = orderProduct.size
        self.sizeLabel.layer.borderWidth = 1.0
        self.sizeLabel.layer.borderColor = UIColor(named: "BlackLP")?.cgColor
        self.sizeLabelWidthConstraint.constant =  self.sizeLabel.intrinsicContentSize.width + 18.0
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

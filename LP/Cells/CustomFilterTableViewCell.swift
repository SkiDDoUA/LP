//
//  CustomFilterTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 09.05.2022.
//

import UIKit

class CustomFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var minPriceTextField: СustomUITextField!
    @IBOutlet weak var maxPriceTextField: СustomUITextField!

    
    static func nib() -> UINib {
        return UINib(nibName: "CustomFilterTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minPriceTextField.setEditActions(only: [])
        maxPriceTextField.setEditActions(only: [])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

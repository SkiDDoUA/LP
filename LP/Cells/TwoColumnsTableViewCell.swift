//
//  TwoColumnsTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 14.02.2022.
//

import UIKit

class TwoColumnsTableViewCell: UITableViewCell {
    @IBOutlet weak var firstSizeLabel: UILabel!
    @IBOutlet weak var secondSizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

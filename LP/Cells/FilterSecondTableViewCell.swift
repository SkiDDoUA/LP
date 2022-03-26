//
//  FilterSecondTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 20.03.2022.
//

import UIKit

class FilterSecondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterParameterTextLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

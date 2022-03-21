//
//  DetailsTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 01.02.2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

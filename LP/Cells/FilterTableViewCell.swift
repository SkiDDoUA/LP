//
//  FilterTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 30.03.2022.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filtersLabel: UILabel!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

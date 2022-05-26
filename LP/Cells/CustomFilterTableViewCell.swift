//
//  CustomFilterTableViewCell.swift
//  LP
//
//  Created by Anton Kolesnikov on 09.05.2022.
//

import UIKit
import RangeSeekSlider

class CustomFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomFilterTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        priceSlider.minLabelFont = UIFont(name: "Helvetica", size: 14.0)!
        priceSlider.maxLabelFont = UIFont(name: "Helvetica", size: 14.0)!
        priceSlider.minDistance = 1.0
        priceSlider.numberFormatter.numberStyle = .none
        priceSlider.tintColor = UIColor(named: "Light GreyLP")
        priceSlider.step = 1.0
        priceSlider.enableStep = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

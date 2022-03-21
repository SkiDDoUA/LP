//
//  CustomHeaderView.swift
//  LP
//
//  Created by Anton Kolesnikov on 17.01.2022.
//

import UIKit

protocol HeaderViewDelegate: class {
    func expandedSection(button: UIButton)
}

class CustomHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: HeaderViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var bottomLineView: UIView!
    
    func configure(title: String, section: Int) {
        titleLabel.text = title
        headerButton.tag = section
        
        headerButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 15)
    }
    
    func rotateImage(_ expanded: Bool) {
        if expanded {
            headerButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } else {
            headerButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
        }
    }
    
    @IBAction func tapHeader(sender: UIButton) {
        delegate?.expandedSection(button: sender)
    }
}

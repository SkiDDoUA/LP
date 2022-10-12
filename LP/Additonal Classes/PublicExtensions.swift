//
//  PublicExtensions.swift
//  LP
//
//  Created by Anton Kolesnikov on 22.08.2022.
//

import UIKit

class Extensions {
    
}

public extension UIColor {
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UINavigationController {
    func transparentNav() {
        self.navigationBar.topItem?.title = " "
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.standardAppearance.shadowColor = .clear
        self.navigationBar.standardAppearance.backgroundColor = .clear
        self.navigationBar.standardAppearance.backgroundEffect = nil
        self.navigationBar.standardAppearance.shadowImage = UIColor.clear.as1ptImage()
        self.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
        self.navigationBar.scrollEdgeAppearance?.backgroundColor = .clear
        self.navigationBar.scrollEdgeAppearance?.backgroundEffect = nil
        self.navigationBar.layoutIfNeeded()
    }
    
    func addBottomLine() {
        self.navigationBar.standardAppearance.shadowImage = UIColor(named: "Light GreyLP")?.as1ptImage()
        self.navigationBar.layoutIfNeeded()
    }
}

public extension UISearchBar {
    func setUpSearchBar() {
        self.sizeToFit()
        self.searchBarStyle = .default
        self.tintColor = UIColor(named: "BlackLP")
        self.barTintColor = UIColor(named: "BlackLP")
        
//        self.layer.cornerRadius = 20
//        self.clipsToBounds = true
        
//        if let textfield = self.value(forKey: "searchField") as? UITextField {
//            textfield.textColor = UIColor.blue
//            if let backgroundview = textfield.subviews.first {
//                backgroundview.layer.cornerRadius = 20;
//                backgroundview.clipsToBounds = true;
//            }
//        }
        
        self.searchTextField.layer.cornerRadius = 20
        self.searchTextField.clipsToBounds = true

        self.searchTextField.font = UIFont(name: "Helvetica", size: 14)
        self.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Поиск", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackLP")!])
        
        if let searchImage = self.searchTextField.leftView as? UIImageView {
            searchImage.image = searchImage.image?.withRenderingMode(.alwaysTemplate)
            searchImage.tintColor = UIColor(named: "BlackLP")
        }
    }
    
    func setCenteredPlaceHolder() {
        let searchBarWidth = self.frame.width
        let placeholderIconWidth = self.searchTextField.leftView?.frame.width
        let placeHolderWidth = self.searchTextField.attributedPlaceholder?.size().width
        let offsetIconToPlaceholder: CGFloat = 20
        let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder
        
        let offset = UIOffset(horizontal: ((searchBarWidth / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon), vertical: 0)
        self.setPositionAdjustment(offset, for: .search)
    }
}

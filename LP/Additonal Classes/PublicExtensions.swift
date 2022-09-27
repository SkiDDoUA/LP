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

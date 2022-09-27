//
//  AppDelegate.swift
//  LP
//
//  Created by Anton Kolesnikov on 12.08.2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      //MARK: - Firebase
      FirebaseApp.configure()
      
      //MARK: - Keyboard Show/Hide
      IQKeyboardManager.shared.enable = true
      IQKeyboardManager.shared.enableAutoToolbar = false
      
      //MARK: - Nagivation Bar Setup
      let navigationBarAppearance = UINavigationBarAppearance()
      navigationBarAppearance.titleTextAttributes = [
          NSAttributedString.Key.backgroundColor: UIColor(named: "WhiteLP"),
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)
      ]
      navigationBarAppearance.backgroundColor = UIColor(named: "WhiteLP")
      navigationBarAppearance.setBackIndicatorImage(UIImage(named: "Left Arrow"), transitionMaskImage: .add)
      navigationBarAppearance.shadowImage = UIColor(named: "Light GreyLP")?.as1ptImage()
      UINavigationBar.appearance().standardAppearance = navigationBarAppearance
      UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    return true
  }
}

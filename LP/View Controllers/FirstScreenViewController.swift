//
//  RegistrationViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 28.08.2021.
//

import UIKit
import InputMask
import ValidationComponents
import CryptoSwift
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class FirstScreenViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    @IBOutlet var listener: MaskedTextFieldDelegate!
    @IBOutlet weak var labelPhoneError: UILabel!
    @IBOutlet weak var phoneTextField: СustomUITextField!
    
    var currentVerificationId: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener.affinityCalculationStrategy = .prefix
        listener.affineFormats = ["[000000000]"]
        phoneTextField.setEditActions(only: [.copy, .cut, .paste])
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        configureTapGesture()
        self.navigationController?.navigationBar.standardAppearance.shadowImage = UIImage()
    }
    
    // MARK: - User Registration (phone for test "+380985568365")
    @IBAction func registrationTapped(_ sender: Any) {
        view.endEditing(true)
                
//        let phone = phoneTextField.fieldValidation(label: labelPhoneError, ValidatorStructure: .phone)
        let phone = "+380985568365"

        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print(error.localizedDescription)
          } else {
              UserDefaults.standard.set(verificationID, forKey: "authID")
              self.performSegue(withIdentifier: "toSMSViewController", sender: Any?.self)
          }
        }
    }
    
    // MARK: - Anonymous Login
    @IBAction func anonymousLoginTapped(_ sender: Any) {
        Auth.auth().signInAnonymously { authResult, error in
            self.performSegue(withIdentifier: "toMainViewController", sender: Any?.self)
        }
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - TapGesture
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

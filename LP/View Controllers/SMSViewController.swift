//
//  SMSViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 30.11.2021.
//

import UIKit
import AEOTPTextField
import FirebaseAuth
import FirebaseFirestore

class SMSViewController: UIViewController, AEOTPTextFieldDelegate {
    
    @IBOutlet weak var otpTextField: AEOTPTextField!
    @IBOutlet weak var wrongCodeLabel: UILabel!
    @IBOutlet weak var rulesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        otpTextField.becomeFirstResponder()
        otpTextField.otpDelegate = self
        otpTextField.configure(with: 6)
        otpTextField.otpTextColor = UIColor(named: "BlackLP")!
        otpTextField.otpFilledBorderColor = UIColor(named: "WhiteLP")!
        otpTextField.otpBackgroundColor = UIColor(named: "Light GreyLP")!
    }
    
    // MARK: User SignIn (otp code for test "111111")
    func didUserFinishEnter(the code: String) {
        self.wrongCodeLabel.isHidden = true
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authID")!, verificationCode: otpTextField.text!)

        Auth.auth().signIn(with: credential) { authData, error in
            if error != nil {
                self.wrongCodeLabel.isHidden = false
                return
            }
            
            let db = Firestore.firestore()
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let userSettings = UserSettings(language: LanguageEnum.ru.rawValue, currency: CurrencyEnum.uah.rawValue, size: SizeEnum.eu.rawValue).toDictionary
            
            db.collection("users").document(userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    self.performSegue(withIdentifier: "toMainViewController", sender: Any?.self)
                } else {
                    do {
                        try db.collection("users").document(userID).setData(["createdAt": Date(), "userSettings": userSettings as Any])
                    } catch let error {
                        print("Error writing user to Firestore: \(error)")
                    }
                    self.performSegue(withIdentifier: "toAdditionalInfoViewController", sender: Any?.self)
                }
            }
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.rulesLabel.frame.origin.y -= keyboardSize.height
        }
    }
    
}

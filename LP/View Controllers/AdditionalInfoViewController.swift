//
//  AdditionalInfoViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 10.12.2021.
//

import UIKit
import WMSegmentControl
import FirebaseAuth
import FirebaseFirestore

class AdditionalInfoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var genderSegmentedControl: WMSegment!
    @IBOutlet weak var birthdayDatePickerTextField: СustomUITextField!
    @IBOutlet weak var brandPickerTextField: СustomUITextField!
    @IBOutlet weak var nameTextField: СustomUITextField!
    @IBOutlet weak var labelNameError: UILabel!
    @IBOutlet weak var labelBirthdayError: UILabel!
    @IBOutlet weak var labelBrandError: UILabel!
    
    var brandData: [String] = [String]()
    var viewPicker = UIPickerView()
    var pickerDateText = Date()
    var genderText = "m"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        
        brandData = ["Отсутствует", "Adidas", "Nike", "Balenciaga", "Kith"]
        
        genderSegmentedControl.SelectedFont = UIFont(name: "Helvetica", size: 12)!
        genderSegmentedControl.normalFont = UIFont(name: "Helvetica", size: 12)!
        viewPicker.dataSource = self
        viewPicker.delegate = self
        viewPicker.backgroundColor = UIColor.systemBackground
        brandPickerTextField.inputView = viewPicker
        brandPickerTextField.setEditActions(only: [])
        birthdayDatePickerTextField.setEditActions(only: [])
        self.brandPickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
        self.birthdayDatePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneDatePicker), type: "date")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // MARK: - User Additional Info
    @IBAction func continueTapped(_ sender: Any) {
        let name = nameTextField.fieldValidation(label: labelNameError, ValidatorStructure: .field)
        let birthday = birthdayDatePickerTextField.fieldValidation(label: labelBirthdayError, ValidatorStructure: .field)
        let brand = brandPickerTextField.fieldValidation(label: labelBrandError, ValidatorStructure: .field)
        
        if name != "" && birthday != "" && brand != "" {
            let db = Firestore.firestore()
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let userAdditionalInfo = UserAdditionalInfo(name: name, gender: genderText, birthdayDate: pickerDateText, favoriteBrand: brand).toDictionary
            do {
                try db.collection("users").document(userID).setData(["userAdditionalInfo": userAdditionalInfo as Any], merge: true)
                self.performSegue(withIdentifier: "toMainViewController", sender: Any?.self)
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            
        }
    }
    
    // MARK: - Skip Additional Info
    @IBAction func skipTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toMainViewController", sender: Any?.self)
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
    
    // MARK: - Set ViewPickers
    @objc func tapDoneDatePicker() {
        if let datePicker = self.birthdayDatePickerTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.locale = Locale(identifier: "ru")
            self.birthdayDatePickerTextField.text = dateformatter.string(from: datePicker.date)
            pickerDateText = datePicker.date
        }
        self.birthdayDatePickerTextField.resignFirstResponder()
    }
    
    @objc func tapDoneViewPicker() {
        self.brandPickerTextField.resignFirstResponder()
    }
    
    // MARK: - Get Index From Segment
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        if sender.selectedSegmentIndex == 0 {
            genderText = "m"
        } else {
            genderText = "w"
        }
    }

}

// MARK: - UIPickerViewDelegate
extension AdditionalInfoViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

// MARK: - UIPickerViewDataSource
extension AdditionalInfoViewController: UIPickerViewDataSource {
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brandData.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brandData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        brandPickerTextField.text = brandData[row]
    }
}

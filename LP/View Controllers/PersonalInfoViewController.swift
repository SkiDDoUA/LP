//
//  UserAdditionalInfoViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 22.08.2022.
//

import UIKit
import WMSegmentControl

class PersonalInfoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var genderSegmentedControl: WMSegment!
    @IBOutlet weak var birthdayDatePickerTextField: СustomUITextField!
    @IBOutlet weak var brandPickerTextField: СustomUITextField!
    @IBOutlet weak var nameTextField: СustomUITextField!
    @IBOutlet weak var labelNameError: UILabel!
    @IBOutlet weak var labelBirthdayError: UILabel!
    @IBOutlet weak var labelBrandError: UILabel!
    
    private var database = Database()
    var brandData: [String] = [String]()
    var viewPicker = UIPickerView()
    var pickerDateText = Date()
    var genderText = "m"
    var user: User! {
        didSet {
            DispatchQueue.main.async {
                self.nameTextField.text = self.user.userAdditionalInfo?.name
                self.genderText = self.user.userAdditionalInfo?.gender ?? "m"
                let birthdayDate = self.user.userAdditionalInfo?.birthdayDate
                if birthdayDate != nil {
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = .medium
                    dateformatter.locale = Locale(identifier: "ru")
                    self.birthdayDatePickerTextField.text = dateformatter.string(from: birthdayDate!)
                } else {
                    self.birthdayDatePickerTextField.text = ""
                }
                self.brandPickerTextField.text = self.user.userAdditionalInfo?.favoriteBrand
            }
        }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Личная информация"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
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
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        let name = nameTextField.fieldValidation(label: labelNameError, ValidatorStructure: .field)
        let birthday = birthdayDatePickerTextField.fieldValidation(label: labelBirthdayError, ValidatorStructure: .field)
        let brand = brandPickerTextField.fieldValidation(label: labelBrandError, ValidatorStructure: .field)
                        
        if name != "" && birthday != "" && brand != "" {
            let userDictionary: [String: Any] = ["name": name, "gender": genderText, "favoriteBrand": brand, "birthdayDate": pickerDateText]
            database.editUserDetails(userDetailsType: .userAdditionalInfo, userData: userDictionary)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - TapGesture
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
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
extension PersonalInfoViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

// MARK: - UIPickerViewDataSource
extension PersonalInfoViewController: UIPickerViewDataSource {
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

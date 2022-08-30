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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Личная информация"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        configureTapGesture()
        genderSegmentedControl.SelectedFont = UIFont(name: "Helvetica", size: 14)!
        genderSegmentedControl.normalFont = UIFont(name: "Helvetica", size: 14)!
        // Do any additional setup after loading the view.
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
}

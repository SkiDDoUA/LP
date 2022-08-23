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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        genderSegmentedControl.SelectedFont = UIFont(name: "Helvetica", size: 14)!
        genderSegmentedControl.normalFont = UIFont(name: "Helvetica", size: 14)!
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AddressBookViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 22.08.2022.
//

import UIKit

class AddressBookViewController: UIViewController {
    @IBOutlet weak var streetView: UIView!
    @IBOutlet weak var flatView: UIView!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var firstNameTextField: СustomUITextField!
    @IBOutlet weak var lastNameTextField: СustomUITextField!
    @IBOutlet weak var patronymicTextField: СustomUITextField!
    @IBOutlet weak var phoneTextField: СustomUITextField!
    @IBOutlet weak var cityPostalOfficeTextField: СustomUITextField!
    @IBOutlet weak var postalOfficeTextField: СustomUITextField!
    @IBOutlet weak var cityCourierTextField: СustomUITextField!
    @IBOutlet weak var streetTextField: СustomUITextField!
    @IBOutlet weak var buildingTextField: СustomUITextField!
    @IBOutlet weak var flatTextField: СustomUITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var patronymicErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var streetErrorLabel: UILabel!
    @IBOutlet weak var buildingErrorLabel: UILabel!
    @IBOutlet weak var flatErrorLabel: UILabel!
    
    private var database = Database()
    var user: User! {
        didSet {
            DispatchQueue.main.async {
                self.firstNameTextField.text = self.user.contactInfo?.firstName
                self.lastNameTextField.text = self.user.contactInfo?.lastName
                self.patronymicTextField.text = self.user.contactInfo?.patronymic
                self.phoneTextField.text = self.user.contactInfo?.phone
                self.cityPostalOfficeTextField.text = self.user.contactInfo?.npPostalOffice?.city
                self.postalOfficeTextField.text = self.user.contactInfo?.npPostalOffice?.postalOffice
                self.cityCourierTextField.text = self.user.contactInfo?.npCourier?.city
                self.streetTextField.text = self.user.contactInfo?.npCourier?.street
                self.buildingTextField.text = self.user.contactInfo?.npCourier?.building
                self.flatTextField.text = self.user.contactInfo?.npCourier?.flat
            }
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Адресная книга"
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.addBottomLine()
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let patronymic = patronymicTextField.text!
        let phone = phoneTextField.text!
        let cityPostalOffice = cityPostalOfficeTextField.text!
        let postalOffice = postalOfficeTextField.text!
        let cityCourier = cityCourierTextField.text!
        let street = streetTextField.text!
        let building = buildingTextField.text!
        let flat = flatTextField.text!
        
        let npCourier = NpCourier(city: cityCourier, street: street, building: building, flat: flat)
        let npPostalOffice = NpPostalOffice(city: cityPostalOffice, postalOffice: postalOffice)
        let userDictionary = ContactInfo(firstName: firstName, lastName: lastName, patronymic: patronymic, phone: phone, npPostalOffice: npPostalOffice, npCourier: npCourier).toDictionary
        database.editUserDetails(userDetailsType: .contactInfo, userData: userDictionary!)
        self.navigationController?.popViewController(animated: true)
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

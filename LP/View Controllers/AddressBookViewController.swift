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
    @IBOutlet weak var cityTextField: СustomUITextField!
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Адресная книга"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        configureTapGesture()
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

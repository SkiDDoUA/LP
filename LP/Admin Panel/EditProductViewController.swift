//
//  EditProductViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 11.11.2022.
//

import UIKit
import WMSegmentControl

class EditProductViewController: UIViewController {
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var availabilitySegmentedControl: WMSegment!
    @IBOutlet weak var nameTextField: СustomUITextField!
    @IBOutlet weak var brandTextField: СustomUITextField!
    @IBOutlet weak var seasonTextField: СustomUITextField!
    @IBOutlet weak var priceTextField: СustomUITextField!
    @IBOutlet weak var currencyTextField: СustomUITextField!
    @IBOutlet weak var discountTextField: СustomUITextField!
    @IBOutlet weak var colorTextField: СustomUITextField!
    @IBOutlet weak var deliveryTermsTextField: СustomUITextField!
    @IBOutlet weak var categoryTextField: СustomUITextField!
    @IBOutlet weak var genderTextField: СustomUITextField!
    @IBOutlet weak var stylecodeTextField: СustomUITextField!
    @IBOutlet weak var materialTextField: СustomUITextField!
    @IBOutlet weak var addSizeTextField: СustomUITextField!
    @IBOutlet weak var sizesCollectionView: UICollectionView!
    @IBOutlet weak var editSizeQuantityTextField: СustomUITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addSizechartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizesCollectionView.layer.borderColor = UIColor(named: "BlackLP")?.cgColor
        sizesCollectionView.layer.borderWidth = 1
        
        configureTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Вещи"
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        viewWidthConstraint?.constant = UIScreen.main.bounds.size.width
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        let name = nameTextField.text!
        let brand = brandTextField.text!
        let season = seasonTextField.text!
        let price = priceTextField.text!
        let currency = currencyTextField.text!
        let discount = discountTextField.text!
        let color = colorTextField.text!
        let delivery = deliveryTermsTextField.text!
        let category = categoryTextField.text!
        let gender = genderTextField.text!
        let stylecode = stylecodeTextField.text!
        let material = materialTextField.text!
        let addSize = addSizeTextField.text!
        let editSizeAmount = editSizeQuantityTextField.text!

        
//        let npCourier = NpCourier(city: cityCourier, street: street, building: building, flat: flat)
//        let npPostalOffice = NpPostalOffice(city: cityPostalOffice, postalOffice: postalOffice)
//        let userDictionary = ContactInfo(firstName: firstName, lastName: lastName, patronymic: patronymic, phone: phone, npPostalOffice: npPostalOffice, npCourier: npCourier).toDictionary
//        database.editUserDetails(userDetailsType: .contactInfo, userData: userDictionary!)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Get Index From Segment
    @IBAction func segmentValueChange(_ sender: WMSegment) {
//        if sender.selectedSegmentIndex == 0 {
//            availabilityCollectionType = .stock
//        } else {
//            availabilityCollectionType = .order
//        }
//        sortStructure = nil
//        filterStructuresArray = []
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


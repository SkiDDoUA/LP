//
//  CustomTextField.swift
//  LP
//
//  Created by Anton Kolesnikov on 02.09.2021.
//

import Foundation
import InputMask
import UIKit

class СustomUITextField: UITextField, UITextFieldDelegate {
    // MARK: - Custom TextField Design
    var placeholderDefault: String?
    
    func setup() {
        self.delegate = self
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        placeholderDefault = self.placeholder
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }

    @objc func textFieldDidBeginEditing() {
        self.borderStyle = .line
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "BlackLP")?.cgColor
        self.layer.backgroundColor = UIColor(named: "WhiteLP")?.cgColor
    }
    
    @objc func textFieldDidEndEditing() {
        self.borderStyle = .none
        self.layer.borderWidth = 0
        if (self.text != nil) {
            if (self.text == "+380 (") {
                self.text = ""
            }
            self.placeholder = placeholderDefault
        }
        self.layer.backgroundColor = UIColor(named: "Light GreyLP")?.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - canPerformAction Setup
    enum ResponderStandardEditActions {
        case cut, copy, paste, select, selectAll, delete
        case makeTextWritingDirectionLeftToRight, makeTextWritingDirectionRightToLeft
        case toggleBoldface, toggleItalics, toggleUnderline
        case increaseSize, decreaseSize

        var selector: Selector {
            switch self {
                case .cut:
                    return #selector(UIResponderStandardEditActions.cut)
                case .copy:
                    return #selector(UIResponderStandardEditActions.copy)
                case .paste:
                    return #selector(UIResponderStandardEditActions.paste)
                case .select:
                    return #selector(UIResponderStandardEditActions.select)
                case .selectAll:
                    return #selector(UIResponderStandardEditActions.selectAll)
                case .delete:
                    return #selector(UIResponderStandardEditActions.delete)
                case .makeTextWritingDirectionLeftToRight:
                    return #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight)
                case .makeTextWritingDirectionRightToLeft:
                    return #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft)
                case .toggleBoldface:
                    return #selector(UIResponderStandardEditActions.toggleBoldface)
                case .toggleItalics:
                    return #selector(UIResponderStandardEditActions.toggleItalics)
                case .toggleUnderline:
                    return #selector(UIResponderStandardEditActions.toggleUnderline)
                case .increaseSize:
                    return #selector(UIResponderStandardEditActions.increaseSize)
                case .decreaseSize:
                    return #selector(UIResponderStandardEditActions.decreaseSize)
            }
        }
    }
    
    private var editActions: [ResponderStandardEditActions: Bool]?
    private var filterEditActions: [ResponderStandardEditActions: Bool]?

    func setEditActions(only actions: [ResponderStandardEditActions]) {
        if self.editActions == nil { self.editActions = [:] }
        filterEditActions = nil
        actions.forEach { self.editActions?[$0] = true }
    }

    func addToCurrentEditActions(actions: [ResponderStandardEditActions]) {
        if self.filterEditActions == nil { self.filterEditActions = [:] }
        editActions = nil
        actions.forEach { self.filterEditActions?[$0] = true }
    }

    private func filterEditActions(actions: [ResponderStandardEditActions], allowed: Bool) {
        if self.filterEditActions == nil { self.filterEditActions = [:] }
        editActions = nil
        actions.forEach { self.filterEditActions?[$0] = allowed }
    }

    func filterEditActions(notAllowed: [ResponderStandardEditActions]) {
        filterEditActions(actions: notAllowed, allowed: false)
    }

    func resetEditActions() { editActions = nil }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let actions = editActions {
            for _action in actions where _action.key.selector == action { return _action.value }
            return false
        }

        if let actions = filterEditActions {
            for _action in actions where _action.key.selector == action { return _action.value }
        }

        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK: - Add Icon To Text Field
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }

    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var rightPadding: CGFloat = 0

    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }

    func updateView() {
        if let image = rightImage {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}

// MARK: - TextField Validaton Extension
public extension UITextField {
    enum ValidatorCase: String {
        case phone
        case email
        case field
    }
    
    internal func fieldValidation(label: UILabel, ValidatorStructure: ValidatorCase, additionalString: String? = nil) -> String {
        do {
            switch ValidatorStructure {
            case .phone:
                let field = try Phone(self.text!)
                label.isHidden = true
                return "+380" + field.textField()
            case .email:
                let field = try Email(self.text!)
                label.isHidden = true
                return field.textField()
            case .field:
                let field = try Field(self.text!)
                label.isHidden = true
                return field.textField()
            }
        } catch let errorField {
            label.text = String(describing: errorField.localizedDescription.description)
            label.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor(named: "RedLP")?.cgColor
                self.layer.backgroundColor = UIColor(named: "WhiteLP")?.cgColor
            })
            return ""
        }
    }
}

// MARK: - TextField ViewPicker Extension
public extension UITextField {
    func setInputViewPicker(target: Any, selector: Selector, type: String? = nil) {
        let screenWidth = UIScreen.main.bounds.width
        
        if type == "date" {
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
            
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -80, to: Date())
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -12, to: Date())
            datePicker.locale = Locale(identifier: "ru")
            
            if #available(iOS 14, *) {
              datePicker.preferredDatePickerStyle = .wheels
              datePicker.sizeToFit()
            }
            datePicker.backgroundColor = UIColor.systemBackground
            self.inputView = datePicker
        }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, doneButton], animated: false)
        toolBar.tintColor = UIColor(named: "BlackLP")
        toolBar.backgroundColor = UIColor(named: "Dark GreyLP")
        self.inputAccessoryView = toolBar
    }

}

//
//  CustomTextFieldStructures.swift
//  LP
//
//  Created by Anton Kolesnikov on 13.09.2021.
//

import Foundation

struct Email {
    private var string: String

    init(_ string: String) throws {
        try CustomTextFieldValidations.email(string)
        self.string = string
    }

    func textField() -> String {
        return string
    }
}

struct Field {
    private var string: String

    init(_ string: String) throws {
        try CustomTextFieldValidations.field(string)
        self.string = string
    }

    func textField() -> String {
        return string
    }
}

struct Phone {
    private var string: String

    init(_ string: String) throws {
        try CustomTextFieldValidations.phone(string)
        self.string = string
    }

    func textField() -> String {
        return string
    }
}

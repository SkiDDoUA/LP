//
//  Validators.swift
//  LP
//
//  Created by Anton Kolesnikov on 06.09.2021.
//

import Foundation

enum EvaluateError: Error {
    case fieldEmptyError
    case fieldLenError
    case emailNotValid
    case phoneNotValid
    case unexpected(code: Int)
}

extension EvaluateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fieldEmptyError:
            return NSLocalizedString(
                "Обязательное поле",
                comment: "Empty Field"
            )
        case .fieldLenError:
            return NSLocalizedString(
                "Слишком длинный текст",
                comment: "Field length limit"
            )
        case .emailNotValid:
            return NSLocalizedString(
                "Некорректная почта",
                comment: "Incorrect email"
            )
        case .phoneNotValid:
            return NSLocalizedString(
                "Некорректный номер",
                comment: "Incorrect phone"
            )
        case .unexpected(_):
            return NSLocalizedString(
                "Неопознанная ошибка",
                comment: "Unexpected error"
            )
        }
    }
}

struct Validations {
    private static let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
        + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    static func email(_ string: String) throws {
        if string.isEmpty == true {
            throw EvaluateError.fieldEmptyError
        }
        
        if maxLength(field: string) == false {
            throw EvaluateError.fieldLenError
        }
        
        if isValid(input: string,
                   regEx: emailRegEx,
                   predicateFormat: "SELF MATCHES[c] %@") == false {
            throw EvaluateError.emailNotValid
        }
    }
    
    static func field(_ string: String) throws {
        if string.isEmpty == true {
            throw EvaluateError.fieldEmptyError
        }
        
        if maxLength(field: string) == false {
            throw EvaluateError.fieldLenError
        }
    }
    
    static func phone(_ string: String) throws {
        if string.isEmpty == true {
            throw EvaluateError.fieldEmptyError
        }
        
        if string.count != 9 {
            throw EvaluateError.phoneNotValid
        }
    }

    private static func isValid(input: String, regEx: String, predicateFormat: String) -> Bool {
        return NSPredicate(format: predicateFormat, regEx).evaluate(with: input)
    }

    private static func maxLength(field: String) -> Bool {
        guard field.count <= 80 else {
            return false
        }
        return true
    }
}

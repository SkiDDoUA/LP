//
//  Schema.swift
//  LP
//
//  Created by Anton Kolesnikov on 15.10.2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// MARK: - Postal Office Structure
public struct NpPostalOffice: Codable {
    let city: String
    let postralOffice: String
    let additionalPhone: String?
}

// MARK: - Courier Structure
public struct NpCourier: Codable {
    let street: String
    let building: String
    let flat: String?
    let additionalPhone: String?
}

// MARK: - Contact Info Structure
public struct ContactInfo: Codable {
    let firstName: String
    let lastName: String
    let patronymic: String
    let phone: String
    let npPostalOffice: NpPostalOffice?
    let npCourier: NpCourier?
}

// MARK: - User Settings Structure
public struct UserSettings: Codable {
    let language: String
    let currency: String
    let size: String
    
    enum CodingKeys: String, CodingKey {
        case language
        case currency
        case size
    }
}

enum LanguageEnum: String, Codable {
    case ru
    case eng
}

enum CurrencyEnum: String, Codable {
    case uah
    case usd
}

enum SizeEnum: String, Codable {
    case eu
    case us
    case ru
}

// MARK: - User Additional Info Structure
public struct UserAdditionalInfo: Codable {
    let name: String
    let gender: String
    let birthdayDate: Date
    let favoriteBrand: String
}

// MARK: - Instock Structure
public struct StockProduct: Identifiable, Codable {
    @DocumentID public var id: String? = UUID().uuidString
    let name: String
    let price: Int
    let brand: ProductBrand
    let images: Array<String>
    let details: ProductDetails
    let stock: Int
}

// MARK: - ProductBrand Structure
public struct ProductBrand: Codable {
    let name: String
    let sizechart: DocumentReference?
}

// MARK: - ProductDetails Structure
public struct ProductDetails: Codable {
    let color: String
    let season: String
    let material: [String : String]
    let size: Array<String>
    let stylecode: String
    let delivery: String
    let type: String
    let gender: String
}

// MARK: - Sizechart Structure
public struct Sizechart: Codable {
    var Default: Array<String>?
    var EU: Array<String>?
    var US: Array<String>?
    var UK: Array<String>?
    var IT: Array<String>?
    var CM: Array<String>?
    var Moncler: Array<String>?
}

// MARK: - Details View Cell Structure
struct ExpandedModel {
    var isExpanded: Bool
    let title: String
    let text: String
}

extension Encodable {
    var toDictionary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}

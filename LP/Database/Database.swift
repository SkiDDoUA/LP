//
//  Database.swift
//  LP
//
//  Created by Anton Kolesnikov on 07.01.2022.
//

import Foundation
import FirebaseFirestore

class Database {
    let db = Firestore.firestore()
        
    enum availabilityCollectionTypes {
        case stock
        case order
    }
    
    enum productCollectionTypes {
        case accessories
        case bags
        case hats
        case hoodie
        case outerwear
        case pants
        case shoes
        case sweatshirts
        case tshirts
        case underwear
        case maincollection
    }

    func getProducts(availabilityCollection: availabilityCollectionTypes, productCollection: productCollectionTypes, handler: @escaping ([Product]) -> Void) {
        db.collection("/men/\(availabilityCollection)/\(productCollection)").addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }
            handler(Product.build(from: data))
        }
    }
    
    func getUser(userID: String, handler: @escaping (User) -> Void) {
        let docRef = db.collection("users").document(userID)
        docRef.addSnapshotListener { documentSnapshot, err in
            guard let data = documentSnapshot else {
                return
            }
            handler(User.build(from: data))
        }
    }
    
    func getUserFavorites(docReference: [DocumentReference], handler: @escaping ([Product], [DocumentReference]) -> Void) {
        var dataArray = [DocumentSnapshot]()
        for document in docReference {
            let docRef = db.document(document.path)
            docRef.addSnapshotListener { documentSnapshot, err in
                guard let data = documentSnapshot else {
                    return
                }
                dataArray.append(data)
                if dataArray.count == docReference.count {
                    handler(Product.buildFavorites(from: dataArray), docReference)
                }
            }
        }
    }
        
    func getSizechart(docReference: DocumentReference, handler: @escaping (Sizechart) -> Void) {
        let docRef = db.document(docReference.path)
        docRef.getDocument { documentSnapshot, err in
            guard let data = documentSnapshot else {
                return
            }
            handler(Sizechart.build(from: data))
        }
    }
    
    func removeFavoriteProduct(userID: String, productReference: DocumentReference) {
        let docRef = db.collection("users").document(userID)
        docRef.updateData(["userFavorites": FieldValue.arrayRemove([productReference])])
    }
}

extension Product {
    static func build(from documents: [QueryDocumentSnapshot]) -> [Product] {
        var products = [Product]()
        for document in documents {
            try? products.append(document.data(as: Product.self)!)
        }
        return products
    }
    
    static func buildFavorites(from documents: [DocumentSnapshot]) -> [Product] {
        var products = [Product]()
        for document in documents {
            try? products.append(document.data(as: Product.self)!)
        }
        return products
    }
}

extension Sizechart {
    static func build(from documents: DocumentSnapshot) -> Sizechart {
        var sizecharts: Sizechart!
        try? sizecharts = documents.data(as: Sizechart.self)!
        return sizecharts
    }
}

extension User {
    static func build(from documents: DocumentSnapshot) -> User {
        var user: User!
        try? user = documents.data(as: User.self)!
        return user
    }
}

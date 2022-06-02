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

    func fetchData(availabilityCollection: availabilityCollectionTypes, productCollection: productCollectionTypes, handler: @escaping ([Product]) -> Void) {
        db.collection("/men/\(availabilityCollection)/\(productCollection)").addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }
            handler(Product.build(from: data))
        }
    }
        
    func getSizechart(docReference: DocumentReference, docCollection: String, handler: @escaping (Sizechart) -> Void) {
        let docRef = Firestore.firestore().collection(docCollection).document(docReference.documentID)
        docRef.getDocument { documentSnapshot, err in
            guard let data = documentSnapshot else {
                return
            }
            handler(Sizechart.build(from: data))
        }
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
}

extension Sizechart {
    static func build(from documents: DocumentSnapshot) -> Sizechart {
        var sizecharts: Sizechart!
        try? sizecharts = documents.data(as: Sizechart.self)!
        return sizecharts
    }
}

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
        db.collection("men").document("\(availabilityCollection)").collection("\(productCollection)").addSnapshotListener { querySnapshot, err in
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
    
    func getUserFavorites(userID: String, handler: @escaping ([FavoriteProduct]) -> Void) {
        db.collection("users").document(userID).collection("favorites").addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }

            var favoriteProducts = [FavoriteProduct]()
            for document in data {
                var dataProduct = try? document.data(as: FavoriteProduct.self)
                let docRef = self.db.document(dataProduct!.reference.path)

                docRef.addSnapshotListener { documentSnapshot, err in
                    guard let dataFav = documentSnapshot else {
                        return
                    }
                    dataProduct!.product = try? dataFav.data(as: Product.self)
                    favoriteProducts.append(dataProduct!)
                    if favoriteProducts.count == data.count {
                        handler(favoriteProducts)
                    }
                }
            }
        }
    }
    
//    func getUserFavorites(userID: String, handler: @escaping ([FavoriteProduct]) -> Void) {
//        db.collection("users").document(userID).collection("favorites").addSnapshotListener { querySnapshot, err in
//            guard let data = querySnapshot?.documents else {
//                return
//            }
//            handler(FavoriteProduct.build(from: data))
//        }
//    }
        
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
        let docRef = db.collection("users").document(userID).collection("favorites")
//        docRef.whereField("refernce", isEqualTo: productReference.path)
    }
}

extension Product {
    static func build(from documents: [QueryDocumentSnapshot]) -> [Product] {
        var products = [Product]()
        for document in documents {
            try? products.append(document.data(as: Product.self))
        }
        return products
    }
}

//extension FavoriteProduct {
//    static func build(from documents: [QueryDocumentSnapshot]) -> [FavoriteProduct] {
//        let db = Firestore.firestore()
//        var favoriteProducts = [FavoriteProduct]()
//
//        for document in documents {
//            var dataProduct = try? document.data(as: FavoriteProduct.self)
//            let docRef = db.document(dataProduct!.reference.path)
//
//            docRef.addSnapshotListener { documentSnapshot, err in
//                guard let data = documentSnapshot else {
//                    return
//                }
//                dataProduct!.product = try? data.data(as: Product.self)
//                favoriteProducts.append(dataProduct!)
////                print(favoriteProducts)
//                print("1")
//            }
//            print("2")
//        }
//        print("3")
//
////        print(favoriteProducts)
//        return favoriteProducts
//    }
//}

extension Sizechart {
    static func build(from documents: DocumentSnapshot) -> Sizechart {
        var sizecharts: Sizechart!
        try? sizecharts = documents.data(as: Sizechart.self)
        return sizecharts
    }
}

extension User {
    static func build(from documents: DocumentSnapshot) -> User {
        var user: User!
        try? user = documents.data(as: User.self)
        return user
    }
}

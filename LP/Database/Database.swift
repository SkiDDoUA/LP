//
//  Database.swift
//  LP
//
//  Created by Anton Kolesnikov on 07.01.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Database {
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser!.uid
        
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
    
    enum userProductsCollectionTypes {
        case cart
        case favorites
    }
    
    func getUserDetails(handler: @escaping (User) -> Void) {
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { documentSnapshot, err in
            guard let data = documentSnapshot else {
                return
            }
            handler(User.build(from: data))
        }
    }
    
    func editUserDetails(userAdditionalInfo: [String: Any]) {
        let docRef = db.collection("users").document(userID)
        docRef.setData(["userAdditionalInfo": userAdditionalInfo], merge: true)
    }

    func getProducts(availabilityCollection: availabilityCollectionTypes, productCollection: productCollectionTypes, handler: @escaping ([UserProduct]) -> Void) {
        let docRef = db.collection("men").document("\(availabilityCollection)").collection("\(productCollection)")
        docRef.addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }
            handler(UserProduct.build(from: data))
        }
    }
    
    func getUserProducts(collection: userProductsCollectionTypes, handler: @escaping ([UserProduct]) -> Void) {
        let docRef = db.collection("users").document(userID).collection("\(collection)")
        docRef.addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }

            var favoriteProducts = [UserProduct]()
            for document in data {
                var dataProduct = try? document.data(as: UserProduct.self)
                let docRef = self.db.document(dataProduct!.reference!.path)

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
        
    func getSizechart(docReference: DocumentReference, handler: @escaping (Sizechart) -> Void) {
        let docRef = db.document(docReference.path)
        docRef.getDocument { documentSnapshot, err in
            guard let data = documentSnapshot else {
                return
            }
            handler(Sizechart.build(from: data))
        }
    }
    
    func removeUserProduct(collection: userProductsCollectionTypes, productReference: DocumentReference) {
        let docRef = db.collection("users").document(userID).collection("\(collection)")
        docRef.document(productReference.documentID).delete()
    }
    
    func addUserProduct(collection: userProductsCollectionTypes, productReference: DocumentReference, size: String? = nil) {
        let docRef = db.collection("users").document(userID).collection("\(collection)").document(productReference.documentID)
        docRef.setData(["reference": db.document(productReference.path), "size": size as Any])
    }
    
    func addUserOrder(order: Order) {
        let docRef = db.collection("users").document(userID).collection("orders")
        do {
            try docRef.addDocument(from: order)
        } catch let error {
            print("Error writing order to Firestore: \(error)")
        }
    }
    
    func getUserOrders(handler: @escaping ([Order]) -> Void) {
        let docRef = db.collection("users").document(userID).collection("orders")
        docRef.addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }
            handler(Order.build(from: data))
        }
    }
}

extension UserProduct {
    static func build(from documents: [QueryDocumentSnapshot]) -> [UserProduct] {
        var products = [UserProduct]()
        for document in documents {
            let product = try? document.data(as: Product.self)
            products.append(UserProduct(isFavorite: false, product: product))
        }
        return products
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

extension Sizechart {
    static func build(from documents: DocumentSnapshot) -> Sizechart {
        var sizecharts: Sizechart!
        try? sizecharts = documents.data(as: Sizechart.self)
        return sizecharts
    }
}

extension Order {
    static func build(from documents: [QueryDocumentSnapshot]) -> [Order] {
        var orders = [Order]()
        for document in documents {
            try? orders.append(document.data(as: Order.self))
        }
        return orders
    }
}

extension User {
    static func build(from documents: DocumentSnapshot) -> User {
        var user: User!
        try? user = documents.data(as: User.self)
        return user
    }
}


//    func createUser(user: User, userExisted: @escaping (Bool) -> Void) {
//        db.collection("users").document(userID).getDocument { (document, error) in
//            if let document = document, document.exists {
//                print("22222222")
//                userExisted(true)
//            } else {
//                do {
//                    try self.db.collection("users").document(self.userID).setData(from: user)
//                } catch let error {
//                    print("Error writing user to Firestore: \(error)")
//                }
//                userExisted(false)
//            }
//        }
//    }

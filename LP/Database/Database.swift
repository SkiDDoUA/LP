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
    let anonymousUser = Auth.auth().currentUser!.isAnonymous
        
    enum availabilityCollectionTypes {
        case stock
        case order
    }
    
    enum productCollectionTypes: CaseIterable {
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
    
    enum userDetailsTypes {
        case userAdditionalInfo
        case contactInfo
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
    
    func editUserDetails(userDetailsType: userDetailsTypes, userData: [String: Any]) {
        let docRef = db.collection("users").document(userID)
        docRef.setData(["\(userDetailsType)": userData], merge: true)
    }
    
    func getProducts(availabilityCollection: availabilityCollectionTypes, productCollection: productCollectionTypes, handler: @escaping ([UserProduct]) -> Void) {
        let docRef = db.collection("men").document("\(availabilityCollection)").collection("\(productCollection)")
        docRef.addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }
            handler(UserProduct.build(from: data, and: []))
        }
    }

    func getProductsWithFavorites(availabilityCollection: availabilityCollectionTypes, productCollection: productCollectionTypes, handler: @escaping ([UserProduct]) -> Void) {
        let docRef = db.collection("men").document("\(availabilityCollection)").collection("\(productCollection)")
        docRef.addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }
            if self.anonymousUser == false {
                self.getUserProducts(collection: .favorites) { favorites in
                    handler(UserProduct.build(from: data, and: favorites))
                }
            } else {
                handler(UserProduct.build(from: data, and: []))
            }
        }
    }
    
    func getFavoriteProductsForSearch(searchProducts: [[UserProduct]], handler: @escaping ([[UserProduct]]) -> Void) {
        if self.anonymousUser == false {
            getUserProducts(collection: .favorites) { favorites in
                handler(UserProduct.buildSearch(from: searchProducts, and: favorites))
            }
        } else {
            handler(searchProducts)
        }
    }
    
    func getUserProducts(collection: userProductsCollectionTypes, handler: @escaping ([UserProduct]) -> Void) {
        let docRef = db.collection("users").document(userID).collection("\(collection)")
        docRef.addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.documents else {
                return
            }
            if !data.isEmpty {
                var productsArray = [UserProduct]()
                for document in data {
                    var dataProduct = try? document.data(as: UserProduct.self)
                    let docRefProduct = self.db.document(dataProduct!.reference!.path)

                    docRefProduct.addSnapshotListener { documentSnapshot, err in
                        guard let dataLocal = documentSnapshot else {
                            return
                        }
                        dataProduct!.product = try? dataLocal.data(as: Product.self)
                        productsArray.append(dataProduct!)
                        if productsArray.count == data.count {
                            handler(productsArray)
                        }
                    }
                }
            } else {
                handler([])
            }
        }
    }
    
    func getProductsForSearch(availabilityCollection: availabilityCollectionTypes, handler: @escaping ([UserProduct]) -> Void) {
        var buildData = [QueryDocumentSnapshot]()
        for (index, type) in productCollectionTypes.allCases.enumerated() {
            let docRef = db.collection("men").document("\(availabilityCollection)").collection("\(type)")
            docRef.addSnapshotListener { querySnapshot, err in
                guard let data = querySnapshot?.documents else {
                    return
                }
                buildData.append(contentsOf: data)
                if index == productCollectionTypes.allCases.endIndex-1 {
                    handler(UserProduct.build(from: buildData, and: []))
                }
            }
        }
    }
            
    func getSizechart(docReference: String, handler: @escaping (Sizechart) -> Void) {
        let docRef = db.document(docReference)
        docRef.getDocument { documentSnapshot, err in
            if documentSnapshot!.exists {
                guard let data = documentSnapshot else {
                    return
                }
                handler(Sizechart.build(from: data))
            } else {
                return
            }
        }
    }
    
    func addUserProduct(collection: userProductsCollectionTypes, product: UserProduct, size: String? = nil, quantity: Int? = 1) {
        if collection == .cart {
            let docRef = db.collection("users").document(userID).collection("\(collection)").document()
            docRef.setData(["reference": db.document(product.product!.reference.path), "cartProductID": docRef.documentID, "size": size as Any, "quantity": quantity as Any])
        } else {
            let docRef = db.collection("users").document(userID).collection("\(collection)").document(product.product!.reference.documentID)
            docRef.setData(["reference": db.document(product.product!.reference.path), "size": size as Any, "quantity": quantity as Any])
        }
    }
    
    func removeUserProduct(collection: userProductsCollectionTypes, product: UserProduct) {
        let docRef = db.collection("users").document(userID).collection("\(collection)")
        if collection == .cart {
            docRef.document(product.cartProductID!).delete()
        } else {
            docRef.document(product.product!.reference.documentID).delete()
        }
    }
    
    func editUserProductCart(cartProduct: UserProduct, size: String, quantity: Int? = nil) {
        let docRef = db.collection("users").document(userID).collection("cart").document(cartProduct.cartProductID!)
        if let quantity {
            docRef.setData(["quantity": quantity], merge: true)
        } else {
            docRef.setData(["size": size], merge: true)
        }
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
    static func build(from products: [QueryDocumentSnapshot], and favoriteProducts: [UserProduct]) -> [UserProduct] {
        var userProducts = [UserProduct]()
        
        if favoriteProducts.count != 0 {
            for document in products {
                let product = try? document.data(as: Product.self)
                if favoriteProducts.filter({$0.reference == product?.reference}).count > 0 {
                    userProducts.append(UserProduct(isFavorite: true, product: product))
                } else {
                    userProducts.append(UserProduct(isFavorite: false, product: product))
                }
            }
        } else {
            for document in products {
                let product = try? document.data(as: Product.self)
                userProducts.append(UserProduct(isFavorite: false, product: product))
            }
        }
        
        return userProducts
    }
    
    static func buildSearch(from products: [[UserProduct]], and favoriteProducts: [UserProduct]) -> [[UserProduct]] {
        var userProducts = products
        
        if !favoriteProducts.isEmpty {
            for (indexCollection, productsCollection) in products.enumerated() {
                for (index, product) in productsCollection.enumerated() {
                    if favoriteProducts.filter({$0.reference == product.product?.reference}).count > 0 {
                        userProducts[indexCollection][index].isFavorite = true
                    } else {
                        userProducts[indexCollection][index].isFavorite = false
                    }
                }
            }
        }
        
        return userProducts
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
//        var sizecharts: Sizechart!
        let sizecharts = try? documents.data(as: Sizechart.self)
//        print(sizecharts)
        return sizecharts!
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
        let user = try? documents.data(as: User.self)
        return user!
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

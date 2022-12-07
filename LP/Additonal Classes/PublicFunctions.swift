////
////  PublicFunctions.swift
////  LP
////
////  Created by Anton Kolesnikov on 11.11.2022.
////
//
//import Foundation
//
//class PublicFunctions {
//}
//
//public func sortSizes(from dictionary: [Size]) -> [Size] {
//    var sortedDictionary = [Size]()
//    let sizeOrder = ["No size", "One size", "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL", "XXXXL"]
//
////    let stringSizeArray = sizeOrder.filter({dictionary.keys.contains($0)})
////    let numberSizeArray = Array(Set(dictionary.keys).subtracting(stringSizeArray)).sorted{$0 < $1}
////    let sortedKeys = stringSizeArray + numberSizeArray
//
////    let ss = SortComparator(sortedKeys)
////
////    print(dictionary.sorted(using: ss))
//
//    let currentPositions = ["RB", "AA", "BB", "CC", "WR", "TE"]
//    let preferredOrder = ["QB", "WR", "RB", "TE"]
////    let ss = dictionary.reorder
//    let sorted = currentPositions.reorder(by: preferredOrder)
//    print(sorted)
//
////    sortedKeys.forEach({ key in
////        print(key)
//////        sortedDictionary.updateValue(dictionary[key]!, forKey: key)
//////        sortedDictionary.
////        sortedDictionary[key] = dictionary[key]
////        print(sortedDictionary)
////    })
//
////    for key in sortedKeys {
//////        sortedDictionary.
////        print(key)
////        sortedDictionary.updateValue(dictionary[key]!, forKey: key)
////        sortedDictionary.
//////        sortedDictionary[key] = dictionary[key]
////        print(sortedDictionary)
////    }
//
////    print(dictionary)
////    print(sortedDictionary)
//
//    return sortedDictionary
//}
//
//
//extension Array where Element: Equatable {
//
//    func reorder(by preferredOrder: [Element]) -> [Element] {
//
//        return self.sorted { (a, b) -> Bool in
//            guard let first = preferredOrder.firstIndex(of: a) else {
//                return false
//            }
//
//            guard let second = preferredOrder.firstIndex(of: b) else {
//                return true
//            }
//
//            return first < second
//        }
//    }
//}

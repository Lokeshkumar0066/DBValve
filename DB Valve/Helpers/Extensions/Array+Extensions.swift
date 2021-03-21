//
//  Array+Extensions.swift
//  ProFive
//
//  Created by Lokesh Kumar on 26/10/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}

extension Sequence where Self == JSONArray {
    func isEqual(to array: JSONArray) -> Bool {
        let array1 = self
        let array2 = array
        
        // Don't equal size => false
        if array1.count != array2.count {
            return false
        }
        let result = zip(array1, array2).enumerated().filter {
            $1.0.isEqual(to: $1.1)
            }.count
        if result == array.count {
            return true
        }
        return false
    }
}



//Reference: https://useyourloaf.com/blog/swift-equatable-and-comparable/

//struct Post : Hashable {
//    var id : Int
//    var hashValue : Int { return self.id }
//}
//
//func == (lhs: Post, rhs: Post) -> Bool {
//    return lhs.id == rhs.id
//}
//
//var posts : [Post] = [Post(id: 1), Post(id: 7), Post(id: 2), Post(id: 1), Post(id: 3), Post(id: 5), Post(id: 7), Post(id: 9)]
////print(posts)
///* [Post(id: 1), Post(id: 7), Post(id: 2), Post(id: 1), Post(id: 3), Post(id: 5), Post(id: 7), Post(id: 9)] */
//
//
//var myUniquePosts = posts.uniq()
////print(myUniquePosts)


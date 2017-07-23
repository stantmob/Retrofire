//
//  Mappable.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import ObjectMapper

/// A type that is used to Map JSON Objects
public protocol Mappable: ObjectMapper.Mappable {}
extension Bool: Mappable {
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public init?(map: Map) { return nil }
    public mutating func mapping(map: Map) {
        self = (map.currentValue as? Bool)!
    }
}
//extension String: Mappable {
//    public init?(map: Map) { return nil }
//    public mutating func mapping(map: Map) {
//        self = (map.currentValue as? String)!
//    }
//}

//extension Int: Mappable {
//    public init?(map: Map) { return nil }
//    public mutating func mapping(map: Map) {
//        self = (map.currentValue as? Int)!
//    }
//}
//extension Float: Mappable {
//    public init?(map: Map) { return nil }
//    public mutating func mapping(map: Map) {
//        self = (map.currentValue as? Float)!
//    }
//}

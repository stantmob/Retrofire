//
//  Mappable.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import ObjectMapper

public protocol Mappable: ObjectMapper.Mappable {}

//extension String: MappableA {
////    public init?(map: Map) { super.init() }
//    public mutating func mapping(map: Map) {
//        self = (map.currentValue as? String)!
//    }
//}
extension Bool: Mappable {
    public /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        return nil
    }
    
    //    public init?(map: Map) { super.init() }
    public mutating func mapping(map: Map) {
        self = (map.currentValue as? Bool)!
    }
}
//extension Int: MappableA {
////    public init?(map: Map) { super.init() }
//    public mutating func mapping(map: Map) {
//        self = (map.currentValue as? Int)!
//    }
//}
//extension Float: MappableA {
////    public init?(map: Map) {}
//    public mutating func mapping(map: Map) {
//        self = (map.currentValue as? Float)!
//    }
//}

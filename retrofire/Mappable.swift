//
//  Mappable.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import SwiftyJSON

/// A type that is used to Map JSON Objects
public protocol Mappable {
    init()
    mutating func map(json: JSON)
}

struct Default: Mappable {
    var json: JSON?
    
    init() {}
    
    public mutating func map(json: JSON) {
        self.json = json
    }
}

extension Bool: Mappable {
    public mutating func map(json: JSON) {
        self = json.boolValue
    }

}
extension String: Mappable {
    public mutating func map(json: JSON) {
        self = json.stringValue
    }
}
extension Int: Mappable {
    public mutating func map(json: JSON) {
        self = json.intValue
    }
}
extension Float: Mappable {
    public mutating func map(json: JSON) {
        self = json.floatValue
    }
}

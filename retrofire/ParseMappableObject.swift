//
//  ParseMappableObject.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import ObjectMapper

/// Responsible to Parse the Result Objects
class ParseMappableObject<T:Mappable> where T: Any {
    static func a(map: ErrorResponse) -> Void {
        //        let m = Mirror.init(reflecting: ab)
        //        for (name, value) in m.children {
        //            guard let name = name else { continue }
        //            print("\(name): \(type(of: value)) = '\(value)'")
        //        }
    }
    
    /// Creates a 'T' instance with the specified attributes from jsonObject.
    ///
    /// - parameter jsonObject: Could be any kind of JSON values.
    ///
    /// - returns: A new T instance with filled attributes got from jsonObject.
    static func parse(jsonObject: Any?) -> T? {
        if (T.self == Bool.self) {
            return true as? T
        }
        
        if (T.self == String.self) {
            return jsonObject as? T
        }
        
        return Mapper<T>().map(JSONObject: jsonObject)
    }
    
    /// Creates a list of 'T' instance with the specified attributes from jsonObject.
    ///
    /// - parameter arrayJsonObject: Could be any kind of array of JSON values.
    ///
    /// - returns: A new list of T instance with filled attributes got from arrayJsonObject.
    static func parseList(arrayJsonObject: Any?) -> [T]? {
        if (arrayJsonObject == nil) {
            return nil
        }
        
        return (arrayJsonObject as! [Any]).reduce([T]()) { (list, jsonObject) in
            var newList = list
            if let object = parse(jsonObject: jsonObject) {
                newList.append(object)
            }
            return newList
        }
    }
}

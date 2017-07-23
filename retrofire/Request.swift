//
//  Request.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Alamofire

// @TODO: Make Request protected

public struct Request {
    var path:            String
    let headers:         [String:String]
    let method:          HTTPMethod
    let queryParameters: [String:String]
    let bodyParameters:  [String:Any?]?
    
    init(path: String, method: HTTPMethodEnum, headers: [String:String], queryParameters: [String:String], bodyParameters: [String:Any?]?) {
        self.path            = path
        self.method          = HTTPMethod.init(rawValue: method.rawValue)!
        self.headers         = headers
        self.queryParameters = queryParameters
        self.bodyParameters  = bodyParameters
    }
    
    public func pathWithQueryParameters() -> String {
        if (queryParameters.count == 0) {
            return self.path
        }
        
        return queryParameters.reduce("\(self.path)?") { (value, map) in
            return "\(value)\(map.key)=\(map.value)&"
        }
    }
    
}

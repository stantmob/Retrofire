//
//  Request.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Alamofire

/// Responsible to know and keep all necessary attributes to use on Alamofire Request
public struct Request {
    let path:            String
    let headers:         [String:String]
    let method:          HTTPMethod
    let queryParameters: [String:String]
    let bodyParameters:  [String:Any?]?
    
    /// Initialize the Request Struct with necessary attributes for Alamofire Request
    ///
    /// - parameter path:            The URl path.
    ///             Sample: path = "http://jsonplaceholder.typicode.com/posts"
    ///                     path = "http://jsonplaceholder.typicode.com/posts/1"
    ///                     path = "http://jsonplaceholder.typicode.com/posts/1/comments"
    ///
    /// - parameter method:          The HTTPMethod. GET, POST, PUT, DELETE etc.
    /// - parameter headers:         The headers for Request.
    ///             Sample: headers = ["Authorization": "Bearer 0eb33842598fd8ea742efacf9964dcc2d16b39baab6f9"]
    ///                     headers = ["Authorization": "Bearer 0eb33842598fd8ea742efacf9964dcc2d16b39baab6f9", "Device-Id": "k91jd82j1d71"]
    ///
    /// - parameter queryParameters: The parameters will join in the path.
    ///             Sample: queryParameters = ["postId": "1", "email": "example@example.com"]
    ///
    /// - parameter bodyParameters:  The body parameters for the Alamofire Request. Can be nil
    ///             Sample: bodyParameters = ["userId": 1, "title": "Some Title", "body": "Some Body"]
    ///
    init(path: String, method: HTTPMethodEnum, headers: [String:String], queryParameters: [String:String], bodyParameters: [String:Any?]?) {
        self.path            = path
        self.method          = HTTPMethod.init(rawValue: method.rawValue)!
        self.headers         = headers
        self.queryParameters = queryParameters
        self.bodyParameters  = bodyParameters
    }
    
    /// Return the joined Path and QueryParameters
    ///
    /// Sample:
    ///         path            = "http://jsonplaceholder.typicode.com/posts/1/comments"
    ///         queryParameters = ["postId": "1", "email": "example@example.com"]
    ///
    /// - returns: "http://jsonplaceholder.typicode.com/comments?postId=1&email=example@example.com&"
    public func pathWithQueryParameters() -> String {
        if (queryParameters.count == 0) {
            return self.path
        }
        
        return queryParameters.reduce("\(self.path)?") { (value, map) in
            return "\(value)\(map.key)=\(map.value)&"
        }
    }
    
}

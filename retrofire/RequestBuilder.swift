//
//  RequestBuilder.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Alamofire

/// Builder for the Request Struct with some default values
///
/// Is recommended to use that Builder insted Request Struct directly
public class RequestBuilder {
    private let path:            String
    private var method:          HTTPMethodEnum = HTTPMethodEnum.get
    private var headers:         [String:String] = [:]
    private var queryParameters: [String:String] = [:]
    private var bodyParameters:  [String:Any?]? = nil

    public init(path: String) {
        self.path = path
    }

    public func build() -> Request {
        return Request.init(path: path, method: method, headers: headers, queryParameters: queryParameters, bodyParameters: bodyParameters)
    }

    public func method(_ method: HTTPMethodEnum) -> RequestBuilder {
        self.method = method
        return self
    }

    public func headers(_ headers: [String:String]) -> RequestBuilder {
        self.headers = headers
        return self
    }

    public func queryParameters(_ queryParameters: [String:String]) -> RequestBuilder {
        self.queryParameters = queryParameters
        return self
    }

    public func bodyParameters(_ bodyParameters: [String:Any?]) -> RequestBuilder {
        self.bodyParameters = bodyParameters
        return self
    }

}

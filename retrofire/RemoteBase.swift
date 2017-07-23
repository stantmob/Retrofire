//
//  RemoteBase.swift
//  retrofire
//
//  Created by Rachid Calazans on 09/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Alamofire
import ObjectMapper

/// HTTP method definitions.
public enum HTTPMethodEnum: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

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

public struct ErrorResponse {
    let statusCode: Int
    let url: String
    let detailMessage: String
}

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

class ParseMappableObject<T:Mappable> where T: Any {
    static func a(map: ErrorResponse) -> Void {
//        let m = Mirror.init(reflecting: ab)
//        for (name, value) in m.children {
//            guard let name = name else { continue }
//            print("\(name): \(type(of: value)) = '\(value)'")
//        }
    }
    
    static func parse(jsonObject: Any?) -> T? {
        if (T.self == Bool.self) {
            return true as? T
        }
        return Mapper<T>().map(JSONObject: jsonObject)
    }
    
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

/**
 RemoteBase is a base class for all Remote classes Implementations will use HTTP requests.
 They need to inherit from RemoteBase.
 */
public class RemoteBase {
    
    public func callSingle<A:Mappable>(request: Request) -> Call<A> {
        let alamofireFunc: (_ executable: Call<A>) -> Void = { exec in
            Alamofire
                .request(request.pathWithQueryParameters(), method: request.method, parameters: request.bodyParameters,
                         encoding: JSONEncoding.default, headers: request.headers)
                .responseJSON { dataResponse in
                    
                    switch(dataResponse.result) {
                    case .success(let value):
                        if self.isErrorStatusCode(response: dataResponse.response!) {
                            exec.failed(error: self.buildErrorResponseFromDataResponse(dataResponse: dataResponse))
                            break
                        }
                        
                        let responseMapped: A? = ParseMappableObject<A>.parse(jsonObject: value)
                        
                        if let response = responseMapped {
                            exec.success(result: response)
                        } else {
                            exec.failed(error: self.buildErrorResponseFromErroMap(klass: A.self))
                        }
                        
                        break
                    case .failure(let error):
                        exec.failed(error: self.buildErrorResponseFromDataResponse(dataResponse: dataResponse, detailMessage: error.localizedDescription))
                        break
                    }
            }
        }
        
        return Call<A>(alamofireFunc)
    }
    
    public func callList<A:Mappable>(request: Request) -> Call<[A]> {
        let alamofireFunc: (_ executable: Call<[A]>) -> Void = { exec in
            Alamofire
                .request(request.pathWithQueryParameters(), method: request.method, parameters: request.bodyParameters,
                         encoding: JSONEncoding.default, headers: request.headers)
                .responseJSON { dataResponse in
                    
                    switch(dataResponse.result) {
                    case .success(let value):
                        if self.isErrorStatusCode(response: dataResponse.response!) {
                            exec.failed(error: self.buildErrorResponseFromDataResponse(dataResponse: dataResponse))
                            break
                        }
                        
                        let responseMapped: [A]? = ParseMappableObject<A>.parseList(arrayJsonObject: value)
                        
                        if let response = responseMapped {
                            exec.success(result: response)
                        } else {
                            exec.failed(error: self.buildErrorResponseFromErroMap(klass: A.self))
                        }
                        break
                        
                    case .failure(let error):
                        exec.failed(error: self.buildErrorResponseFromDataResponse(dataResponse: dataResponse, detailMessage: error.localizedDescription))
                        break
                    }
            }
        }
        
        return Call<[A]>(alamofireFunc)
    }
    
    private func buildErrorResponseFromErroMap(klass: Any.Type) -> ErrorResponse {
        let detailMessage = "Error when try to map the \(klass)"
        return ErrorResponse.init(statusCode: 0, url: "", detailMessage: detailMessage)
    }
    
    private func buildErrorResponseFromDataResponse(dataResponse: DataResponse<Any>, detailMessage: String = "") -> ErrorResponse {
        let url        = dataResponse.request!.url!.absoluteString
        let statusCode = dataResponse.response!.statusCode
        return ErrorResponse(statusCode: statusCode, url: url, detailMessage: detailMessage)
    }
    
    private func isErrorStatusCode(response : HTTPURLResponse) -> Bool {
        return !isResponseStatusCodeSuccess(response: response)
    }
    
    private func isResponseStatusCodeSuccess(response : HTTPURLResponse) -> Bool{
        return response.statusCode == 200
            || response.statusCode == 201
            || response.statusCode == 203
            || response.statusCode == 304
    }
    
//    private func isInvalidResponseStatusCode(response: HTTPURLResponse?) -> Bool{
//        if response == nil {
//            return false
//        }
//        
//        return response!.statusCode == 500
//            || response!.statusCode == 401
//            || response!.statusCode == 403
//    }
    
}

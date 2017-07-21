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
public enum HTTPMethodEnumA: String {
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

public struct RequestA {
    var path:            String
    let headers:         [String:String]
    let method:          HTTPMethod
    let queryParameters: [String:String]
    let bodyParameters:  [String:String]
    
    init(path: String, method: HTTPMethodEnumA, headers: [String:String], queryParameters: [String:String], bodyParameters: [String:String]) {
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

public class RequestABuilder {
    private let path:            String
    private var method:          HTTPMethodEnumA = HTTPMethodEnumA.get
    private var headers:         [String:String] = [:]
    private var queryParameters: [String:String] = [:]
    private var bodyParameters:  [String:String] = [:]
    
    public init(path: String) {
        self.path = path
    }
    
    public func build() -> RequestA {
        return RequestA.init(path: path, method: method, headers: headers, queryParameters: queryParameters, bodyParameters: bodyParameters)
    }
    
    public func method(_ method: HTTPMethodEnumA) -> RequestABuilder {
        self.method = method
        return self
    }
    
    public func headers(_ headers: [String:String]) -> RequestABuilder {
        self.headers = headers
        return self
    }
    
    public func queryParameters(_ queryParameters: [String:String]) -> RequestABuilder {
        self.queryParameters = queryParameters
        return self
    }
    
    public func bodyParameters(_ bodyParameters: [String:String]) -> RequestABuilder {
        self.bodyParameters = bodyParameters
        return self
    }
     
}

public struct ErrorResponse {
    let statusCode: Int
    let url: String
    let detailMessage: String
}

public protocol MappableA: Mappable {}

// TODO: Change class name to ParseMappableObject
class ParseResponse<T: MappableA> {
    static func a(map: ErrorResponse) -> Void {
//        let m = Mirror.init(reflecting: ab)
//        for (name, value) in m.children {
//            guard let name = name else { continue }
//            print("\(name): \(type(of: value)) = '\(value)'")
//        }
    }
    
    static func parse(jsonObject: Any?) -> T? {
        return Mapper<T>().map(JSONObject: jsonObject)
    }
    
    static func parseList(arrayJsonObject: Any?) -> [T]? {
        if let array = arrayJsonObject {
            var list = [T]()
            for jsonObject in array as! [Any] {
                let mapped = parse(jsonObject: jsonObject)
                if let object = mapped {
                    list.append(object)
                }
            }
            return list
        }
        
        return nil
    }
}

/**
 RemoteBase is a base class for all Remote classes Implementations will use HTTP requests.
 They need to inherit from RemoteBase.
 */
public class RemoteBase {
    
    public func callSingle<A: MappableA>(request: RequestA) -> Call<A> {
        let alamofireFunc: (_ executable: Call<A>) -> Void = { exec in
            Alamofire
                .request(request.pathWithQueryParameters(), method: request.method, parameters: nil,
                         encoding: JSONEncoding.default, headers: request.headers)
                .responseJSON { dataResponse in
                    
                    switch(dataResponse.result) {
                    case .success(let value):
                        if self.isResponseStatus200NoErrorServer(response: dataResponse.response!) {
                            
                            let responseMapped: A? = ParseResponse<A>.parse(jsonObject: value)
                            
                            if let response = responseMapped {
                                exec.success(result: response)
                            } else {
                                let detailMessage = "Error when try to map the \(A.self)"
                                let errorResponse = ErrorResponse.init(statusCode: 0, url: "", detailMessage: detailMessage)
                                exec.failed(error: errorResponse)
                            }
                            
                            break
                            
                        } else {
                            let url = dataResponse.request!.url!.absoluteString
                            let statusCode = dataResponse.response!.statusCode
                            let errorResponse = ErrorResponse(statusCode: statusCode, url: url, detailMessage: "")
                            exec.failed(error: errorResponse)
                            break
                        }
                        
                    case .failure(let error):
                        exec.failed()
                        break
                    }
            }
        }
        
        return Call<A>(alamofireFunc)
    }
    
    public func callList<A: MappableA>(request: RequestA) -> Call<[A]> {
        let alamofireFunc: (_ executable: Call<[A]>) -> Void = { exec in
            Alamofire
                .request(request.pathWithQueryParameters(), method: request.method, parameters: nil,
                         encoding: JSONEncoding.default, headers: request.headers)
                .responseJSON { dataResponse in
                    
                    switch(dataResponse.result) {
                    case .success(let value):
                        if self.isResponseStatus200NoErrorServer(response: dataResponse.response!) {
                        
                            let responseMapped: [A]? = ParseResponse<A>.parseList(arrayJsonObject: value)
                        
                            if let response = responseMapped {
                                exec.success(result: response)
                            } else {
                                let detailMessage = "Error when try to map the \(A.self)"
                                let errorResponse = ErrorResponse.init(statusCode: 0, url: "", detailMessage: detailMessage)
                                exec.failed(error: errorResponse)
                                //                                apiCallback(BaseCallback<[ConstructionSiteResponse]>.failed(error: "Erro when try to map the ConstructionSiteResponse"))
                            }
                            
                            break
            
                        } else {
                            let url = dataResponse.request!.url!.absoluteString
                            let statusCode = dataResponse.response!.statusCode
                            let errorResponse = ErrorResponse(statusCode: statusCode, url: url, detailMessage: "")
                            exec.failed(error: errorResponse)
//                            let errorResponseMapped: ErrorResponseToMap? = ParseResponse<ErrorResponseToMap>.parse(jsonObject: value)
                        
//                            if let errorResponse = errorResponseMapped {
//                                exec.failed()
                                //                                exec.failed(error: errorResponse)
//                            } else {
//                                exec.failed()
                                //                                apiCallback(BaseCallback<[ConstructionSiteResponse]>.failed(error: "Erro when try to map the AuthErrorResponse"))
                                //                            }
                                
//                            }
                            break
                        }
                        
                    case .failure(let error):
//                        let e: Error = error
                        exec.failed()
                        //                        let callbackFail = BaseCallback<[ConstructionSiteResponse]>.failed(error: error)
                        //                        apiCallback(callbackFail)
                        break
//                    }
                    }
            }
        }
        
        return Call<[A]>(alamofireFunc)
    }
    
    private func isResponseStatus200NoErrorServer(response : HTTPURLResponse) -> Bool {
        if isResponseStatusCodeSuccess(response: response) {
            return true
        }
        return false
    }
    
    private func isResponseStatusCodeSuccess(response : HTTPURLResponse) -> Bool{
        return response.statusCode == 200
            || response.statusCode == 201
            || response.statusCode == 203
            || response.statusCode == 304
    }
    
    private func isInvalidResponseStatusCode(response: HTTPURLResponse?) -> Bool{
        if response != nil {
            return response!.statusCode == 500
                || response!.statusCode == 401
                || response!.statusCode == 403
        }
        
        return false
    }
    
}

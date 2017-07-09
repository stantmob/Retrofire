//
//  RemoteBase.swift
//  retrofire
//
//  Created by Rachid Calazans on 09/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Alamofire
import ObjectMapper

public class Request {
    var path:    String          = ""
    let headers: [String:String] = [:]
    let method:  HTTPMethod      = .get
}

public class ErrorResponse {
    var statusCode: Int?
    var url: String?
    var detailMessage: String?
}

// TODO: Change class name to ParseMappableObject
class ParseResponse<T: Mappable> {
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
//    public func callSingle<A>(request: Request) -> Call<A> {
//        return Call<A>(<#(Call<T>) -> Void#>)
//    }
    
    public func callList<A: Mappable>(request: Request) -> Call<[A]> {
        let alamofireFunc: (_ executable: Call<[A]>) -> Void = { exec in
            Alamofire
                .request(request.path, method: request.method, parameters: nil,
                         encoding: JSONEncoding.default, headers: request.headers)
                .responseJSON { dataResponse in
                    
                    switch(dataResponse.result) {
                    case .success(let value):
                        if self.isResponseStatus200NoErrorServer(response: dataResponse.response!) {
                        
                            let responseMapped: [A]? = ParseResponse<A>.parseList(arrayJsonObject: value)
                        
                            if let response = responseMapped {
                                exec.success(result: response)
                            } else {
                                let errorResponse = ErrorResponse()
                                errorResponse.detailMessage = "Error when try to map the \(A.self)"
                                exec.failed(error: errorResponse)
                                //                                apiCallback(BaseCallback<[ConstructionSiteResponse]>.failed(error: "Erro when try to map the ConstructionSiteResponse"))
                            }
                            
                            break
            
                        } else {
                            let errorResponse = ErrorResponse()
                            errorResponse.statusCode = dataResponse.response!.statusCode
                            errorResponse.url = dataResponse.request?.url!.absoluteString
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

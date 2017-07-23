//
//  RemoteBase.swift
//  retrofire
//
//  Created by Rachid Calazans on 09/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Alamofire
import ObjectMapper


/// RemoteBase is a base class for all Remote classes Implementations will use HTTP requests.
/// They need to inherited from RemoteBase.
public class RemoteBase {
    
    /// Return a Call<ResponseObject> to be used on Remote classes implementations
    ///
    /// - parameter request: The request object to be used on Alamofire.request. 
    ///
    /// - returns: Return a Call<ResponseObject> with the result object based on ResponseObject or ErrorResponse (if Alamofire gets failures) inside the Call.
    public func callSingle<ResponseObject:Mappable>(request: Request) -> Call<ResponseObject> {
        let alamofireFunc: (_ executable: Call<ResponseObject>) -> Void = { exec in
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
                        
                        let responseMapped: ResponseObject? = ParseMappableObject<ResponseObject>.parse(jsonObject: value)
                        
                        if let response = responseMapped {
                            exec.success(result: response)
                        } else {
                            exec.failed(error: self.buildErrorResponseFromErroMap(klass: ResponseObject.self))
                        }
                        
                        break
                    case .failure(let error):
                        exec.failed(error: self.buildErrorResponseFromDataResponse(dataResponse: dataResponse, detailMessage: error.localizedDescription))
                        break
                    }
            }
        }
        
        return Call<ResponseObject>(alamofireFunc)
    }
    
    /// Return a Call<[ResponseObject]> to be used on Remote classes implementations
    ///
    /// - parameter request: The request object to be used on Alamofire.request.
    ///
    /// - returns: Return a Call<[ResponseObject]> with the list of result objects based on ResponseObject or ErrorResponse (if Alamofire gets failures) inside the Call.
    public func callList<ResponseObject:Mappable>(request: Request) -> Call<[ResponseObject]> {
        let alamofireFunc: (_ executable: Call<[ResponseObject]>) -> Void = { exec in
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
                        
                        let responseMapped: [ResponseObject]? = ParseMappableObject<ResponseObject>.parseList(arrayJsonObject: value)
                        
                        if let response = responseMapped {
                            exec.success(result: response)
                        } else {
                            exec.failed(error: self.buildErrorResponseFromErroMap(klass: ResponseObject.self))
                        }
                        break
                        
                    case .failure(let error):
                        exec.failed(error: self.buildErrorResponseFromDataResponse(dataResponse: dataResponse, detailMessage: error.localizedDescription))
                        break
                    }
            }
        }
        
        return Call<[ResponseObject]>(alamofireFunc)
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

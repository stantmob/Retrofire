//
//  HTTPMethodEnum.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

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

//
//  ErrorResponse.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

/// Responsible to know and keep all necessary attributes to use on RemoteBase failures
public struct ErrorResponse {
    let statusCode: Int
    let url: String
    let detailMessage: String
}

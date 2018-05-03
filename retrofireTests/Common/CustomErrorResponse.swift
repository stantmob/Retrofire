//
//  CustomErrorResponse.swift
//  Retrofire
//
//  Created by Stant 02 on 03/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import Retrofire

struct CustomErrorResponse: Retrofire.Mappable {
    let responseType: String?
    let message: String?
    let trace: [String]?
    
    static func instanceBy<M>(json: JSON) -> M {
        let responseType = json.dictionary?["response_type"]?.stringValue
        let message      = json.dictionary?["message"]?.stringValue
        let trace        = json.dictionary?["trace"]?.arrayObject as? [String]
        
        return CustomErrorResponse.init(responseType: responseType, message: message, trace: trace) as! M
    }
}

//
//  ResponseObject.swift
//  Retrofire
//
//  Created by Stant 02 on 03/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import Retrofire

public struct ResponseObject: Retrofire.Mappable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
    
    public static func instanceBy<M>(json: JSON) -> M {
        let userId = json.dictionary?["userId"]?.int
        let id     = json.dictionary?["id"]?.int
        let title  = json.dictionary?["title"]?.string
        let body   = json.dictionary?["body"]?.string
        
        return ResponseObject.init(userId: userId, id: id, title: title, body: body) as! M
    }
}

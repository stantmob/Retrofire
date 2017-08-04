//
//  Mappable.swift
//  retrofire
//
//  Created by Rachid Calazans on 23/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import SwiftyJSON

/// A type that is used to Map JSON Objects
public protocol Mappable {
    static func instanceBy<M>(json: JSON) -> M
}

public struct Default: Mappable {
    let json: JSON

    static func instanceBy<M>(json: JSON) -> M {
        return Default(json: json) as! M
    }
}

extension Bool: Mappable {
    public static func instanceBy<M>(json: JSON) -> M {
        return json.boolValue as! M
    }

}
extension String: Mappable {
    public static func instanceBy<M>(json: JSON) -> M {
        return json.stringValue as! M
    }
}
extension Int: Mappable {
    public static func instanceBy<M>(json: JSON) -> M {
        return json.intValue as! M
    }
}
extension Float: Mappable {
    public static func instanceBy<M>(json: JSON) -> M {
        return json.floatValue as! M
    }
}

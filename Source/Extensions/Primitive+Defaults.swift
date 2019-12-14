//
//  Primitive+Defaults.swift
//  Snapshots
//
//  Created by Paul Napier on 4/12/19.
//  Copyright © 2019 RNDM. All rights reserved.
//

import Foundation
import UIKit

extension String: Primitive {}
extension Int: Primitive {}
extension Int8: Primitive {}
extension Int16: Primitive {}
extension Int32: Primitive {}
extension Int64: Primitive {}
extension Float: Primitive {}
extension Double: Primitive {}
extension Bool: Primitive {
    public var rawValue: Primitive {
        return self
    }
}

extension CGFloat: Primitive {}
extension CGPoint: Primitive {}
extension CGSize: Primitive {}
extension CGRect: Primitive {}

extension Primitive where Self: CustomStringConvertible {
    public var rawValue: Primitive {
        return description
    }
}

extension JSONObject: Primitive {
    public var rawValue: Primitive {
        return reduce([String: Any](), {
            var output = $0
            if let primitive = $1.value as? Primitive {
                output[$1.key] = primitive.rawValue
            } else {
                output[$1.key] = Snapshot($1.value).dictionary
            }
            return output
        })
    }
}

extension JSONArray: Primitive {
    public var rawValue: Primitive {
        return map {
            if let primitive = $0 as? Primitive {
                return primitive.rawValue
            } else {
                return Snapshot($0).dictionary
            }
        }
    }
}

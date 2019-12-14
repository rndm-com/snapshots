//
//  Primitive.swift
//  Snapshots
//
//  Created by Paul Napier on 4/12/19.
//  Copyright © 2019 RNDM. All rights reserved.
//

import Foundation

public
protocol Primitive {
    var rawValue: Primitive { get }
}

public
extension Primitive {
    var rawValue: Primitive {
        return self
    }
}

//
//  Snapshottable.swift
//  Snapshots
//
//  Created by Paul Napier on 4/12/19.
//  Copyright © 2019 RNDM. All rights reserved.
//

import Foundation

public
protocol Snapshottable {
    var children: [String: Any] { get }
}

public
extension Snapshottable {
    var mirror: Mirror {
        return Mirror(self, children: Mirror(reflecting: self)
            .children
            .reduce(children) {
            var output = $0
            if let label = $1.label {
                output[label] = $1.value
            }
            return output
        }
        .map { (label: $0.key, value: $0.value) })
    }
}

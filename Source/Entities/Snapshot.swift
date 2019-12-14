//
//  Snapshot.swift
//  Snapshots
//
//  Created by Paul Napier on 4/12/19.
//  Copyright © 2019 RNDM. All rights reserved.
//

import Foundation

public
struct Snapshot {
    let object: Any

    public init(_ object: Any) {
        self.object = object
    }

    var dictionary: [String: Any] {
        let mirror = (object as? Snapshottable)?.mirror ?? Mirror(reflecting: object)
        return mirror.children.reduce([String: Any]()) {
            var output = $0
            if let label = $1.label {
                output[label] = ($1.value as? Primitive)?.rawValue ?? Snapshot($1.value).dictionary
            }
            return output
        }
    }

    private var data: Data {
        return try! JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted, .sortedKeys])
    }

    public var snapshot: String {
        return String(data: data, encoding: .utf8)!
    }
}

public extension Snapshot {
    static let preferredBasePath = "_snaps"
}

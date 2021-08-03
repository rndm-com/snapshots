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
        guard String(describing: object) != "nil" else { return [:] }
        let mirror = (object as? Snapshottable)?.mirror ?? Mirror(reflecting: object)
        return mirror.children.reduce([String: Any]()) {
            var output = $0
            if let label = $1.label, String(describing: $1.value) != "nil" {
                output[label] = derive(value: $1.value)
            }
            return output
        }
    }
    private func derive(value: Any) -> Any {
        return (value as? Primitive)?.rawValue
            ?? (value as? [Primitive])?.map { $0.rawValue }
            ?? Snapshot(value).dictionary
    }

    private var data: Data {
        return try! JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted, .sortedKeys])
    }

    public var snapshot: String {
        return String(data: data, encoding: .utf8)!
    }
}

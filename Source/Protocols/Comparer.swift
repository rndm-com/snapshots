//
//  Comparer.swift
//  Snapshots
//
//  Created by Paul Napier on 4/12/19.
//  Copyright © 2019 RNDM. All rights reserved.
//

import Foundation

typealias JSONObject = [String: Any]
typealias JSONArray = [Any]

public
struct Comparer {
    let lhs: String
    let rhs: String
    public init(lhs: String, rhs: String) {
        self.lhs = lhs
        self.rhs = rhs
    }
}

extension Comparer {
    public func compare() -> String {
        return test(key: "", lhs: lhs.json, rhs: rhs.json) ?? ""
    }

    private func test<T: Equatable>(key: String, lhs: T?, rhs: T?) -> String? {
        switch (lhs, rhs) {
        case (.some(let lhs), .some(let rhs)) where lhs != rhs:
            return "~key: \(key), expected: \(lhs), actual: \(rhs)~"
        case (.some(let lhs), .none):
            return "~key: \(key), expected: \(lhs), actual: \(String(describing: rhs == nil ? nil : rhs!))~"
        default:
            return nil
        }
    }

    private func test(key: String, lhs: JSONObject?, rhs: JSONObject?) -> String? {
        if let lhs = lhs {
            if let rhs = rhs {
                var message: String = ""
                lhs.forEach {
                    let outKey = [key, $0.key].filter { !$0.isEmpty }.joined(separator: ".")
                    let output = test(key: outKey, lhs: $0.value as? Bool, rhs: rhs[$0.key] as? Bool)
                    ?? test(key: outKey, lhs: $0.value as? Int, rhs: rhs[$0.key] as? Int)
                    ?? test(key: outKey, lhs: $0.value as? Float, rhs: rhs[$0.key] as? Float)
                    ?? test(key: outKey, lhs: $0.value as? Double, rhs: rhs[$0.key] as? Double)
                    ?? test(key: outKey, lhs: $0.value as? String, rhs: rhs[$0.key] as? String)
                    ?? test(key: outKey, lhs: $0.value as? JSONObject, rhs: rhs[$0.key] as? JSONObject)
                    ?? test(key: outKey, lhs: $0.value as? JSONArray, rhs: rhs[$0.key] as? JSONArray)
                    ?? ""
                    message.append(output)
                }
                if case let missing = lhs - rhs, !missing.isEmpty {
                    missing.forEach {
                        message.append("~new key value paring: \(key).\($0.key) = \($0.value)~")
                    }
                }
                return message
            }
            return "~key: \(key), expected: \(lhs), actual: \(String(describing: rhs))~"
        }
        return nil
    }

    private func test(key: String, lhs: JSONArray?, rhs: JSONArray?) -> String? {
        if let lhs = lhs {
            if let rhs = rhs, lhs.count == rhs.count {
                var message: String = ""
                lhs.enumerated().forEach {
                    let outKey = [key, "\($0.offset)"].filter { !$0.isEmpty }.joined(separator: ".")
                    let output = test(key: outKey, lhs: $0.element as? Bool, rhs: rhs[$0.offset] as? Bool)
                    ?? test(key: outKey, lhs: $0.element as? Int, rhs: rhs[$0.offset] as? Int)
                    ?? test(key: outKey, lhs: $0.element as? Float, rhs: rhs[$0.offset] as? Float)
                    ?? test(key: outKey, lhs: $0.element as? Double, rhs: rhs[$0.offset] as? Double)
                    ?? test(key: outKey, lhs: $0.element as? String, rhs: rhs[$0.offset] as? String)
                    ?? test(key: outKey, lhs: $0.element as? JSONObject, rhs: rhs[$0.offset] as? JSONObject)
                    ?? test(key: outKey, lhs: $0.element as? JSONArray, rhs: rhs[$0.offset] as? JSONArray)
                    ?? ""
                    message.append(output)
                }

                return message
            }
            return "\nkey \(key) expected: \(lhs) - actual: \(String(describing: rhs))"
        }
        return nil
    }
}

private extension String {
    private var base: Data {
        return data(using: .utf8)!
    }
    var json: JSONObject {
        return try! JSONSerialization.jsonObject(with: base, options: .init()) as! [String: Any]
    }
    var prepared: String {
        let data = try! JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
        return String(data: data, encoding: .utf8)!
    }
}

private func - (lhs: JSONObject, rhs: JSONObject) -> JSONObject {
    return Array(Set(rhs.keys).subtracting(Set(lhs.keys))).reduce([String: Any]()) {
        var output = $0
        if let value = rhs[$1] {
            output[$1] = value
        }
        return output
    }
}

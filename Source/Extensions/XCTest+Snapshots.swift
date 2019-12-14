//
//  XCTest+Snapshots.swift
//  Snapshots
//
//  Created by Paul Napier on 4/12/19.
//  Copyright © 2019 RNDM. All rights reserved.
//

import XCTest

public
extension XCTestCase {
    func snapshot(for object: Snapshot,
                  path: String = Snapshot.preferredBasePath,
                  overwrite: Bool = false,
                  function: String = #function,
                  name: String = #function) -> String {
        let regex = #"(\(|\))"#
        let filename = [classForCoder, function, name]
            .map { "\($0)" }.joined(separator: "_")
            .replacingOccurrences(of: regex, with: "", options: .regularExpression)
        let projectDirectory = URL(fileURLWithPath: Bundle(for: classForCoder).infoDictionary!["PROJECT_DIR"] as? String ?? "")
        let documentsDirectory = projectDirectory.appendingPathComponent(path)
        let path = documentsDirectory.appendingPathComponent(filename).appendingPathExtension("json")
        if !overwrite, let string = try? String(contentsOf: path) {
            return string
        } else {
            try! object.snapshot.write(to: path, atomically: true, encoding: .utf8)
        }
        return object.snapshot
    }

    func XCTAssertSnapshot(_ sut: Any,
                           path: String = Snapshot.preferredBasePath,
                           overwrite: Bool = false,
                           function: String = #function,
                           name: String = #function,
                           file: StaticString = #file,
                           line: UInt = #line) {
        let snap = Snapshot(sut)
        let expectation = snapshot(for: snap, path: path, overwrite: overwrite, function: function, name: name)
        let result = snap.snapshot
        XCTAssertEqual(expectation, result, Comparer(lhs: expectation, rhs: result).compare(), file: file, line: line)
    }
}

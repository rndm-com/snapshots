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
                  config: SnapshotConfig = .standard,
                  function: String = #function,
                  file: StaticString = #file,
                  name: String = #function) -> String {
        let regex = #"(\(|\))"#
        let filename = [classForCoder, function, name]
            .map { "\($0)" }.joined(separator: "_")
            .replacingOccurrences(of: regex, with: "", options: .regularExpression)
        let projectDirectory = URL(fileURLWithPath: Bundle(for: classForCoder).infoDictionary!["PROJECT_DIR"] as? String ?? "")
        let documentsDirectory = config.storageType.directory(in: projectDirectory, file: file.description, basePath: config.basePath)
        try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        let path = documentsDirectory.appendingPathComponent(filename).appendingPathExtension("json")
        if !config.overwrite, let string = try? String(contentsOf: path) {
            return string
        } else {
            try! object.snapshot.write(to: path, atomically: true, encoding: .utf8)
        }
        return object.snapshot
    }

    func XCTAssertSnapshot(_ sut: Any,
                           config: SnapshotConfig = .standard,
                           function: String = #function,
                           name: String = #function,
                           file: StaticString = #file,
                           line: UInt = #line) {
        let snap = Snapshot(sut)
        let expectation = snapshot(for: snap, config: config, function: function, file: file, name: name)
        let result = snap.snapshot
        let comparison = Comparer(lhs: expectation, rhs: result).compare()
        if expectation != result {
            XCTFail("\(name) --- \(comparison)", file: file, line: line)
        } else {
            XCTAssertEqual(expectation, result, comparison, file: file, line: line)
        }
    }
}

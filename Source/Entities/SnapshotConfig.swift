//
//  SnapshotConfig.swift
//  Snapshots
//
//  Created by Paul Napier on 20/1/20.
//  Copyright © 2020 RNDM. All rights reserved.
//

import Foundation

public
class SnapshotConfig {
    public
    enum StorageType {
        case flat
        case byFile
        case byFolderAndFile
        case byFolder
        case relativeToFile
    }
    public static let standard = SnapshotConfig()
    public static let overwrite: SnapshotConfig = {
        $0.overwrite = true
        return $0
    }(SnapshotConfig())
    
    public var overwrite = false
    public var basePath = "_snaps"
    public var storageType: StorageType = .byFile
}

extension SnapshotConfig.StorageType {
    func directory(in projectDirectory: URL, file: String, basePath: String = SnapshotConfig.standard.basePath) -> URL {
        let relativePath = file.replacingOccurrences(of: projectDirectory.absoluteString.replacingOccurrences(of: "file://", with: ""), with: "")
        switch self {
        case .flat:
            return projectDirectory.appendingPathComponent(basePath)
        case .byFile:
            let fileName = relativePath.components(separatedBy: "/").last?.components(separatedBy: ".").first
            return projectDirectory
                .appendingPathComponent(basePath)
                .appendingPathComponent(fileName ?? "_unknown")
        case .byFolder:
            let directory = relativePath.components(separatedBy: "/").filter { $0.hasSuffix(".swift") }.joined(separator: "/")
            return projectDirectory.appendingPathComponent(basePath).appendingPathComponent(directory)
        case .byFolderAndFile:
            let directory = relativePath.replacingOccurrences(of: ".swift", with: "")
            return projectDirectory.appendingPathComponent(basePath).appendingPathComponent(directory)
        case .relativeToFile:
            let directory = relativePath.components(separatedBy: "/").filter { !$0.hasSuffix(".swift") }.joined(separator: "/")
            return projectDirectory.appendingPathComponent(directory).appendingPathComponent(basePath)
        }
    }
}

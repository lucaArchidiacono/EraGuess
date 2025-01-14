//
//  LogRotation.swift
//
//
//  Created by Luca Archidiacono on 30.04.2024.
//

import Foundation

public enum LogRotation {
    private struct LogData {
        var path: URL
        var size: UInt64
        var creationDate: Date
    }

    public struct Options {
        let storageSizeLimit: Int
        let oldestAllowedDate: Date

        /// Options for log rotation, defining how logs should be retained.
        ///
        /// - Parameter storageSizeLimit: Storage size limit in bytes.
        /// - Parameter oldestAllowedDate: Oldest allowed date.
        public init(storageSizeLimit: Int, oldestAllowedDate: Date) {
            self.storageSizeLimit = storageSizeLimit
            self.oldestAllowedDate = oldestAllowedDate
        }
    }

    public enum Error: LocalizedError {
        case rotateLogFiles(Swift.Error)

        public var errorDescription: String? {
            switch self {
            case .rotateLogFiles:
                "Failure to rotate the source log file to backup."
            }
        }

        public var underlyingError: Swift.Error? {
            switch self {
            case let .rotateLogFiles(error):
                error
            }
        }
    }

    public static func rotateLogs(logDirectory: URL, options: Options) throws {
        let fileManager = FileManager.default

        do {
            // Filter out all log files in directory.
            let logPaths: [URL] = try (fileManager.contentsOfDirectory(
                atPath: logDirectory.relativePath
            )).compactMap { file in
                if file.split(separator: ".").last == "log" {
                    logDirectory.appendingPathComponent(file)
                } else {
                    nil
                }
            }

            // Convert logs into objects with necessary meta data.
            let logs = try logPaths.map { logPath in
                let attributes = try fileManager.attributesOfItem(atPath: logPath.relativePath)
                let size = (attributes[.size] as? UInt64) ?? 0
                let creationDate = (attributes[.creationDate] as? Date) ?? Date.distantPast

                return LogData(path: logPath, size: size, creationDate: creationDate)
            }.sorted { log1, log2 in
                log1.creationDate > log2.creationDate
            }

            try deleteLogsOlderThan(options.oldestAllowedDate, in: logs)
            try deleteLogsWithCombinedSizeLargerThan(options.storageSizeLimit, in: logs)
        } catch {
            throw Error.rotateLogFiles(error)
        }
    }

    private static func deleteLogsOlderThan(_ dateThreshold: Date, in logs: [LogData]) throws {
        let fileManager = FileManager.default

        for log in logs where log.creationDate < dateThreshold {
            try fileManager.removeItem(at: log.path)
        }
    }

    private static func deleteLogsWithCombinedSizeLargerThan(_ sizeThreshold: Int, in logs: [LogData]) throws {
        let fileManager = FileManager.default

        // Delete all logs outside maximum capacity (ordered newest to oldest).
        var fileSizes = UInt64.zero
        for log in logs {
            fileSizes += log.size

            if fileSizes > sizeThreshold {
                try fileManager.removeItem(at: log.path)
            }
        }
    }
}

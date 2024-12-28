//
//  Logger.swift
//
//
//  Created by Luca Archidiacono on 30.04.2024.
//

import FileLogging
import Foundation
import Fundamentals
@_exported import Logging

private enum LoggerOutput {
    case fileOutput(_ fileOutput: FileLogging)
    case osLogOutput(_ subsystem: String)
}

public struct LogBuilder {
    private(set) var fileLogErrors: [Error] = []
    private var outputs: [LoggerOutput] = []

    public var metadata: Logger.Metadata = [:]
    public var logLevel: Logger.Level = .debug

    public init() {}

    public mutating func addFileOutput(fileURL: URL) {
        let logsDirectoryURL = fileURL.deletingLastPathComponent()

        try? FileManager.default.createDirectory(
            at: logsDirectoryURL,
            withIntermediateDirectories: false,
            attributes: nil
        )

        do {
            try LogRotation.rotateLogs(logDirectory: logsDirectoryURL, options: LogRotation.Options(
                storageSizeLimit: 5_242_880, // 5 MB
                oldestAllowedDate: Date(timeIntervalSinceNow: -Duration.days(7).timeInterval)
            ))

            let fileLogger = try FileLogging(to: fileURL)
            outputs.append(.fileOutput(fileLogger))
        } catch {
            fileLogErrors.append(error)
        }
    }

    public mutating func addOSLogOutput(subsystem: String) {
        outputs.append(.osLogOutput(subsystem))
    }

    public func install() {
        LoggingSystem.bootstrap { label in
            let handlers: [LogHandler] = outputs.map { output in
                switch output {
                case let .fileOutput(fileLogger):
                    FileLogHandler(label: label, fileLogger: fileLogger)
                case let .osLogOutput(subsystem):
                    OSLogHandler(subsystem: subsystem, category: label)
                }
            }

            if handlers.isEmpty {
                return SwiftLogNoOpLogHandler()
            } else {
                var multiplex = MultiplexLogHandler(handlers)
                multiplex.metadata = metadata
                multiplex.logLevel = logLevel
                return multiplex
            }
        }

        if !fileLogErrors.isEmpty {
            let rotationLogger = Logger(label: "FileLogging")

            for error in fileLogErrors {
                rotationLogger.error("\(error.localizedDescription)")
            }
        }
    }
}

//
//  OSLogHandler.swift
//
//
//  Created by Luca Archidiacono on 30.04.2024.
//

import Foundation
import Logging
import os

public struct OSLogHandler: LogHandler {
    public var metadata: Logging.Logger.Metadata = [:]
    public var logLevel: Logging.Logger.Level = .debug

    private let label: String
    private let osLog: OSLog

    private struct RegistryKey: Hashable {
        let subsystem: String
        let category: String
    }

    private static var osLogRegistry: [RegistryKey: OSLog] = [:]
    private static let registryLock = NSLock()

    private static func getOSLog(subsystem: String, category: String) -> OSLog {
        registryLock.lock()
        defer { registryLock.unlock() }

        let key = RegistryKey(subsystem: subsystem, category: category)
        if let log = osLogRegistry[key] {
            return log
        } else {
            let newLog = OSLog(subsystem: subsystem, category: category)
            osLogRegistry[key] = newLog
            return newLog
        }
    }

    public init(subsystem: String, category: String) {
        label = category
        osLog = OSLogHandler.getOSLog(subsystem: subsystem, category: category)
    }

    public subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }

    // swiftlint:disable:next function_parameter_count
    public func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        source _: String,
        file _: String,
        function _: String,
        line _: UInt
    ) {
        let mergedMetadata = self.metadata
            .merging(metadata ?? [:]) { _, rhs -> Logging.Logger.MetadataValue in
                rhs
            }
        let prettyMetadata = Self.formatMetadata(mergedMetadata)
        let logMessage = prettyMetadata.isEmpty ? "\(level.emoji) \(message)" : "\(prettyMetadata) \(level.emoji) \(message)"

        os_log("%{public}s", log: osLog, type: level.osLogType, "\(logMessage)")
    }

    private static func formatMetadata(_ metadata: Logging.Logger.Metadata) -> String {
        metadata.map { "\($0)=\($1)" }.joined(separator: " ")
    }
}

private extension Logging.Logger.Level {
    var osLogType: OSLogType {
        switch self {
        case .trace, .debug:
            // Console app does not output .debug logs, use .info instead.
            .info
        case .info, .notice, .warning:
            .info
        case .error, .critical:
            .error
        }
    }

    var emoji: String {
        switch self {
        case .trace:
            "🏁"
        case .notice:
            "✅"
        case .debug:
            "🪲"
        case .info:
            "ℹ️"
        case .warning:
            "⚠️"
        case .error, .critical:
            "🔥"
        }
    }
}

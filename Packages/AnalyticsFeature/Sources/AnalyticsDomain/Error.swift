//
//  Error.swift
//  AnalyticsFeature
//
//  Created by Luca Archidiacono on 16.10.2024.
//

import Foundation

public enum Error: Swift.Error, LocalizedError {
    case serialization(Encodable & Sendable)

    public var errorDescription: String? {
        switch self {
        case let .serialization(value):
            "Failed to serialize \(value)"
        }
    }
}

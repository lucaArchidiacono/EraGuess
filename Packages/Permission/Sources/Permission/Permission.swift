//
//  Permission.swift
//
//
//  Created by Luca Archidiacono on 13.07.2024.
//

import Foundation

public struct Permission: Sendable {
    public enum `Type`: Sendable {
        case notifications
        case location
    }

    public enum Status: Int, Sendable {
        case authorized
        case denied
        case notDetermined

        public var description: String {
            switch self {
            case .authorized:
                "authorized"
            case .denied:
                "denied"
            case .notDetermined:
                "notDetermined"
            }
        }
    }

    public let type: `Type`
    public let status: Status

    public init(type: Type, status: Status) {
        self.type = type
        self.status = status
    }
}

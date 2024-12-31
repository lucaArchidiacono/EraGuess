//
//  Event.swift
//  AnalyticsFeature
//
//  Created by Luca Archidiacono on 16.10.2024.
//

import Foundation
import Fundamentals
import Permission

public enum Event: Sendable {
    public enum State: String, Sendable {
        case active
        case background
        case inactive
    }

    public enum PermissionType: String, Sendable {
        case notification = "Notification"
        case gps = "GPS"
        case musicKit = "MusicKit"
    }

    public enum Request: Sendable {
        case permission(PermissionType, status: Permission.Status)

        package var rawValue: String {
            switch self {
            case .permission:
                "Permission"
            }
        }
    }

    public enum Feature: Sendable {
        case intent(String)

        package var rawValue: String {
            switch self {
            case .intent:
                "Intent"
            }
        }
    }

    case view(name: String)
    case state(State)
    case request(Request)
    case feature(Feature, parameters: [String: String] = [:])

    package var rawValue: String {
        switch self {
        case .view:
            "View"
        case .state:
            "State"
        case .request:
            "Request"
        case .feature:
            "Feature"
        }
    }

    package var signalName: String {
        var signalName = [String]()

        switch self {
        case let .view(name):
            signalName.append(rawValue)
            signalName.append(name)
        case let .state(type) where type == .inactive: // Not interested into inactive state
            break
        case let .state(type):
            signalName.append(rawValue)
            signalName.append(type.rawValue)
        case let .request(type):
            signalName.append(rawValue)
            signalName.append(type.rawValue)

            switch type {
            case let .permission(type, value):
                signalName.append(type.rawValue)
                signalName.append(value.description)
            }
        case let .feature(feature, _):
            signalName.append(rawValue)
            signalName.append(feature.rawValue)
        }

        return signalName
            .map(\.capitalized)
            .joined(separator: ".")
    }

    package var parameters: [String: String] {
        switch self {
        case let .feature(_, parameters):
            parameters
        default:
            [:]
        }
    }
}

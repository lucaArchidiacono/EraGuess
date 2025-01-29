//
//  TelemetryDeckManager.swift
//  AnalyticsFeature
//
//  Created by Luca Archidiacono on 10.11.2024.
//

import AnalyticsDomain
import Foundation
import Fundamentals
import Logger
import Permission
import TelemetryDeck

public struct TelemetryDeckConfiguration: AnalyticsConfiguration {
    public let appName: String
    public let apiKey: String
    public let securityGroupIdentifier: String

    public init(
        appName: String,
        apiKey: String,
        securityGroupIdentifier: String
    ) {
        self.appName = appName
        self.apiKey = apiKey
        self.securityGroupIdentifier = securityGroupIdentifier
    }
}

public final class TelemetryDeckManager: AnalyticsManager {
    private let logger = Logger(label: String(describing: TelemetryDeckManager.self))
    private let permissions: [any PermissionProvider]

    private let configuration: TelemetryDeckConfiguration
    public var appID: String { configuration.apiKey }

    public var hashedDefaultUser: String {
        get async {
            await TelemetryManager.shared.hashedDefaultUser
        }
    }

    public init(
        configuration: TelemetryDeckConfiguration,
        permissions: [any PermissionProvider]
    ) {
        self.configuration = configuration
        self.permissions = permissions

        let config = TelemetryDeck.Config(
            appID: appID
        )

        #if DEBUG
            config.testMode = true
        #endif

        config.defaultSignalPrefix = "App."
        config.defaultParameterPrefix = "\(configuration.appName)."

        TelemetryDeck.initialize(config: config)
    }

    public func updateDefault(userID: String) {
        TelemetryDeck.updateDefaultUserID(to: userID)
    }

    public func track(event: Event) {
        let signalName = event.signalName

        Task { [weak self] in
            guard let self else { return }

            var defaultParameters: [String: String] = [:]

            for permission in permissions {
                let status = await permission.fetchStatus()

                switch permission {
                case is NotificationPermissionProvider:
                    defaultParameters["notificationPermission"] = status.description
                case is MusicKitPermissionProvider:
                    defaultParameters["musicKitPermission"] = status.description
                case is LocationPermissionProvider:
                    defaultParameters["locationPermission"] = status.description
                default:
                    logger.warning("Unknown permission provider: \(permission)")
                    continue
                }
            }

            let parameters = event
                .parameters
                .merging(defaultParameters, uniquingKeysWith: { _, new in new })
                .reduce(into: [String: String]()) { partialResult, keyValue in
                    let nonCapitalizedKey = keyValue.key.prefix(1).lowercased() + keyValue.key.dropFirst()
                    partialResult[nonCapitalizedKey] = keyValue.value
                }

            #if DEBUG
                logger.debug("⚛️ Tracking:\n - Event: \(signalName)\n - Props: \(parameters)")
            #endif

            TelemetryDeck.signal(
                signalName,
                parameters: parameters
            )
        }
    }
}

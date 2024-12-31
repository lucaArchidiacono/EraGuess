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
    private let logger = Logger(label: "TelemetryDeckManager")
    private let notificationPermissionProvider: NotificationPermissionProvider
    private let musicKitPermissionProvider: MusicKitPermissionProvider

    public init(
        configuration: TelemetryDeckConfiguration,
        notificationPermissionProvider: NotificationPermissionProvider,
        musicKitPermissionProvider: MusicKitPermissionProvider
    ) {
        self.notificationPermissionProvider = notificationPermissionProvider
        self.musicKitPermissionProvider = musicKitPermissionProvider

        let config = TelemetryDeck.Config(
            appID: configuration.apiKey
        )

        #if DEBUG
            config.testMode = true
        #endif

        config.defaultSignalPrefix = "App."
        config.defaultParameterPrefix = "\(configuration.appName)."

        TelemetryDeck.initialize(config: config)
    }

    public func track(event: Event) {
        let signalName = event.signalName

        Task { [weak self] in
            guard let self else { return }

            let notificationPermissionStatus = await notificationPermissionProvider.fetchStatus()
            let musicKitPermissionStatus = await musicKitPermissionProvider.fetchStatus()

            let defaultParameters: [String: String] = [
                "notificationPermission": notificationPermissionStatus.description,
                "musicKitPermission": musicKitPermissionStatus.description,
            ]

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

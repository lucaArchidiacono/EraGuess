//
//  SubscriptionConfiguration.swift
//
//
//  Created by Luca Archidiacono on 13.07.2024.
//

import Foundation

public struct SubscriptionConfiguration {
    public let revenueCatAPIKey: String
    public let securityGroupIdentifier: String

    public init(
        revenueCatAPIKey: String,
        securityGroupIdentifier: String
    ) {
        self.revenueCatAPIKey = revenueCatAPIKey
        self.securityGroupIdentifier = securityGroupIdentifier
    }
}

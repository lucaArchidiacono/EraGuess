//
//  SubscriptionInfo.swift
//
//
//  Created by Luca Archidiacono on 18.07.2024.
//

import Foundation

public struct SubscriptionInfo: Codable, Equatable, Sendable {
    public let identifier: String
    public let isActive: Bool

    public init(
        identifier: String,
        isActive: Bool
    ) {
        self.identifier = identifier
        self.isActive = isActive
    }
}

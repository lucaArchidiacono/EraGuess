//
//  SubscriptionManager.swift
//
//
//  Created by Luca Archidiacono on 18.07.2024.
//

import Foundation
import RevenueCat

public protocol SubscriptionManager: Sendable {
    subscript(_: Entitlement) -> AsyncStream<SubscriptionDomain.SubscriptionInfo> { get }
    func fetchPackages(using offeringID: String) async -> [Package]
    func buy(_ package: Package) async
}

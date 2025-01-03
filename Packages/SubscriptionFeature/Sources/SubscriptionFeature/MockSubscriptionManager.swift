//
//  MockSubscriptionManager.swift
//
//
//  Created by Luca Archidiacono on 18.07.2024.
//

import Foundation
import RevenueCat
import SubscriptionDomain

public final class MockSubscriptionManager: SubscriptionManager {
    private nonisolated
    let subscriptions: [String: SubscriptionDomain.SubscriptionInfo]
    private let packages: [String]
    private let streamStore = StreamStore()

    public subscript(value: Entitlement) -> SubscriptionDomain.SubscriptionInfo {
        subscriptions[value.rawValue] ?? SubscriptionInfo(identifier: value.rawValue, isActive: false)
    }

    public subscript(value: SubscriptionDomain.Entitlement) -> AsyncStream<SubscriptionDomain.SubscriptionInfo> {
        AsyncStream { continuation in
            let id = UUID().uuidString

            continuation.onTermination = { @Sendable [weak self] _ in
                self?.streamStore.removeStream(using: id)
            }

            streamStore.addStream(using: id, (value, continuation))

            let subscriptionInfo: SubscriptionDomain.SubscriptionInfo = self[value]

            continuation.yield(subscriptionInfo)
        }
    }

    public init(
        subscriptions: [SubscriptionDomain.SubscriptionInfo],
        packages: [String]
    ) {
        self.subscriptions = subscriptions.reduce(into: [String: SubscriptionDomain.SubscriptionInfo]()) { partialResult, info in
            partialResult[info.identifier] = info
        }
        self.packages = packages
    }

    public func fetchPackages(using offeringID: String) async -> [Package] {
        packages.map { id in
            Package(
                identifier: id,
                packageType: .unknown,
                storeProduct: TestStoreProduct(
                    localizedTitle: "Small Tip",
                    price: 1.0,
                    localizedPriceString: "1 CHF",
                    productIdentifier: id,
                    productType: .nonConsumable,
                    localizedDescription: "Small Tip for 1 CHF"
                ).toStoreProduct(),
                offeringIdentifier: offeringID
            )
        }
    }

    public func buy(_ package: Package) async {
        print("Successfully bought the package: \(package)")
    }
}

//
//  SubscriptionManagerImpl.swift
//  CasaZurigo
//
//  Created by Luca Archidiacono on 25.05.2024.
//

import Foundation
import Fundamentals
import Logger
import RevenueCat
import SubscriptionDomain

public actor SubscriptionManagerImpl: SubscriptionManager {
    private let logger = Logger(label: "SubscriptionManager")

    private var subscriptonInfos: [String: SubscriptionDomain.SubscriptionInfo] {
        set {
            guard let data = try? JSONCoders.encoder.encode(newValue) else { return }

            UserDefaults.standard.set(data, forKey: "entitlements")

            for (value, continuation) in streams.values {
                let subscriptionInfo: SubscriptionDomain.SubscriptionInfo = self[value]
                continuation.yield(subscriptionInfo)
            }
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: "entitlements"),
                  let dict = try? JSONCoders.decoder.decode([String: SubscriptionDomain.SubscriptionInfo].self, from: data)
            else { return [:] }

            return dict
        }
    }

    private subscript(value: Entitlement) -> SubscriptionDomain.SubscriptionInfo {
        subscriptonInfos[value.rawValue] ?? SubscriptionInfo(identifier: value.rawValue, isActive: false)
    }

    public subscript(value: SubscriptionDomain.Entitlement) -> AsyncStream<SubscriptionDomain.SubscriptionInfo> {
        AsyncStream { continuation in
            let id = streams.count + 1

            continuation.onTermination = { @Sendable [weak self] _ in
                Task {
                    await self?.removeCurrentSubscriptionStream(using: id)
                }
            }

            streams[id] = (value, continuation)

            let subscriptionInfo: SubscriptionDomain.SubscriptionInfo = self[value]

            continuation.yield(subscriptionInfo)
        }
    }

    private var streams: [Int: (Entitlement, AsyncStream<SubscriptionDomain.SubscriptionInfo>.Continuation)] = [:]

    public init(configuration: SubscriptionConfiguration) {
        #if DEBUG
            Purchases.logLevel = .debug
        #else
            Purchases.logLevel = .verbose
        #endif

        Purchases.configure(
            with: Configuration.builder(withAPIKey: configuration.revenueCatAPIKey)
                .with(userDefaults: .init(suiteName: configuration.securityGroupIdentifier)!)
                .build()
        )

        Task.detached { [weak self] in
            for await customerInfo in Purchases.shared.customerInfoStream {
                guard let self else { return }

                await checkEntitlement(using: customerInfo)
            }
        }
    }

    private func checkEntitlement(using customerInfo: CustomerInfo) async {
        let entitlements = customerInfo.entitlements

        let subscriptonInfos = entitlements
            .all
            .reduce(into: [String: SubscriptionDomain.SubscriptionInfo]()) { partialResult, newValue in
                let entitlementInfo = newValue.value
                partialResult[newValue.key] = SubscriptionInfo(
                    identifier: entitlementInfo.identifier,
                    isActive: entitlementInfo.isActive
                )
            }
        self.subscriptonInfos = subscriptonInfos
    }

    public func fetchPackages(using offeringID: String) async -> [RevenueCat.Package] {
        do {
            logger.trace("Start fetching Packages from RevenueCat using: \(offeringID)")

            let offerings = try await Purchases.shared.offerings()
            let packages = offerings[offeringID]?.availablePackages ?? []
            logger.notice("Finished fetching Pacakges from RevenueCat with result: \(packages)")
            return packages
        } catch {
            logger.error("Failed to fetch Offerings from RevenueCat with error: \(error)")
            return []
        }
    }

    public func buy(_ package: RevenueCat.Package) async {
        do {
            logger.trace("Start making purchase from RevenueCat with package: \(package)")

            let customerInfo = try await Purchases.shared.purchase(package: package)
            logger.notice("Finished making purchase from RevenueCat with result: \(customerInfo)")
        } catch {
            logger.error("Failed to make purchase with error: \(error)")
        }
    }

    private func removeCurrentSubscriptionStream(using id: Int) {
        streams.removeValue(forKey: id)
    }
}

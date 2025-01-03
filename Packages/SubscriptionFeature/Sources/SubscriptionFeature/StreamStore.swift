//
//  StreamStore.swift
//  SubscriptionFeature
//
//  Created by Luca Archidiacono on 03.01.2025.
//

import Foundation
import SubscriptionDomain

final class StreamStore: @unchecked Sendable {
    private var streams: [String: (Entitlement, AsyncStream<SubscriptionDomain.SubscriptionInfo>.Continuation)] = [:]
    private let lock = NSLock()

    var count: Int {
        lock.withLock { streams.count }
    }

    var values: Dictionary<String, (Entitlement, AsyncStream<SubscriptionDomain.SubscriptionInfo>.Continuation)>.Values {
        lock.withLock { streams.values }
    }

    func addStream(using id: String, _ stream: (Entitlement, AsyncStream<SubscriptionDomain.SubscriptionInfo>.Continuation)) {
        lock.withLock { streams[id] = stream }
    }

    @discardableResult
    func removeStream(using id: String) -> (Entitlement, AsyncStream<SubscriptionDomain.SubscriptionInfo>.Continuation)? {
        lock.withLock { streams.removeValue(forKey: id) }
    }
}

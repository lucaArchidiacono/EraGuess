//
//  MockAnalyticsManager.swift
//  AnalyticsFeature
//
//  Created by Luca Archidiacono on 16.10.2024.
//

import AnalyticsDomain
import Logger

public final class MockAnalyticsManager: AnalyticsManager {
    private let logger = Logger(label: "AnalyticsManager")

    public init() {}

    public func track(event: Event) {
        logger.debug("Track \(event)")
    }
}

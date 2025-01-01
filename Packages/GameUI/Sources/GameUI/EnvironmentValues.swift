//
//  EnvironmentValues.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import SwiftUI
import HapticFeedbackFeature
import AnalyticsDomain
import AnalyticsFeature

@MainActor
private struct HapticFeedbackManagerKey: @preconcurrency EnvironmentKey {
    static let defaultValue: HapticFeedbackManager = .init()
}

private struct AnalyticsManagerKey: EnvironmentKey {
    static let defaultValue: any AnalyticsManager = MockAnalyticsManager()
}

extension EnvironmentValues {
    var hapticFeedbackManager: HapticFeedbackManager {
        get { self[HapticFeedbackManagerKey.self] }
        set { self[HapticFeedbackManagerKey.self] = newValue }
    }
    
    var analyticsManager: AnalyticsManager {
        get { self[AnalyticsManagerKey.self] }
        set { self[AnalyticsManagerKey.self] = newValue }
    }
}

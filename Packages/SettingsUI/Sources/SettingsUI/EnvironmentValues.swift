//
//  EnvironmentValues.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 01.01.2025.
//

import SwiftUI
import AnalyticsDomain
import AnalyticsFeature
import Permission

private struct AnalyticsManagerKey: EnvironmentKey {
    static let defaultValue: any AnalyticsManager = MockAnalyticsManager()
}

private struct MusicKitPermissionProviderKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: MusicKitPermissionProvider = MusicKitPermissionProvider()
}

extension EnvironmentValues {
    var analyticsManager: AnalyticsManager {
        get { self[AnalyticsManagerKey.self] }
        set { self[AnalyticsManagerKey.self] = newValue }
    }
    var musicKitPermissionProvider: MusicKitPermissionProvider {
        get { self[MusicKitPermissionProviderKey.self] }
        set { self[MusicKitPermissionProviderKey.self] = newValue }
    }
}

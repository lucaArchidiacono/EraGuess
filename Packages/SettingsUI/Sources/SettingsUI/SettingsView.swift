//
//  SettingsView.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import AnalyticsDomain
import EraGuessUI
import Permission
import SharedUI
import StateFeature
import SwiftUI
import UINavigation

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    private let router: Router<SettingsUI.Destination, SettingsUI.Page>
    private let musicKitPermissionProvider: MusicKitPermissionProvider
    private let analyticsManager: AnalyticsManager
    private let userPreferencesManager: UserPreferencesManager
    private let appStateManager: AppStateManager

    public init(
        router: Router<SettingsUI.Destination, SettingsUI.Page>,
        musicKitPermissionProvider: MusicKitPermissionProvider,
        analyticsManager: AnalyticsManager,
        userPreferencesManager: UserPreferencesManager,
        appStateManager: AppStateManager
    ) {
        self.router = router
        self.musicKitPermissionProvider = musicKitPermissionProvider
        self.analyticsManager = analyticsManager
        self.userPreferencesManager = userPreferencesManager
        self.appStateManager = appStateManager
    }

    public var body: some View {
        content
            .navigationTitle("Settings")
            .toolbar {
                TextToolbar("Done", placement: .topBarTrailing) {
                    dismiss()
                }
            }
            .environment(router)
            .environment(userPreferencesManager)
            .environment(appStateManager)
            .environment(\.musicKitPermissionProvider, musicKitPermissionProvider)
            .environment(\.analyticsManager, analyticsManager)
            .onAppear {
                analyticsManager.track(
                    event: .view(
                        name: String(describing: SettingsView.self)
                    )
                )
            }
    }

    private var content: some View {
        List {
            userPreferencesSection
            streamingServicesSection
            languageSetSection
            extrasSection
        }
    }

    private var languageSetSection: some View {
        LanguageSetSection()
    }

    private var streamingServicesSection: some View {
        StreamingServiceSection()
    }

    private var userPreferencesSection: some View {
        UserPreferencesSection()
    }

    private var extrasSection: some View {
        ExtrasSection()
    }
}

//
//  SettingsView.swift
//  SettingsUI
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import AnalyticsDomain
import EraGuessUI
import Permission
import SharedUI
import SwiftUI
import UINavigation
import StateFeature

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    private let router: Router<SettingsUI.Destination, SettingsUI.Page>
    private let musicKitPermissionProvider: MusicKitPermissionProvider
    private let analyticsManager: AnalyticsManager
    private let userPreferencesManager: UserPreferencesManager

    public init(
        router: Router<SettingsUI.Destination, SettingsUI.Page>,
        musicKitPermissionProvider: MusicKitPermissionProvider,
        analyticsManager: AnalyticsManager,
        userPreferencesManager: UserPreferencesManager
    ) {
        self.router = router
        self.musicKitPermissionProvider = musicKitPermissionProvider
        self.analyticsManager = analyticsManager
        self.userPreferencesManager = userPreferencesManager
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
            streamingServicesSection
            userPreferencesSection
            extrasSection
        }
    }

    private var streamingServicesSection: some View {
        StreamingServiceSection(
            musicKitPermissionProvider: musicKitPermissionProvider
        )
    }
    
    private var userPreferencesSection: some View {
        UserPreferencesSection(
            musicKitPermissionProvider: musicKitPermissionProvider
        )
    }

    private var extrasSection: some View {
        ExtrasSection()
    }
}

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

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    private let router: Router<SettingsUI.Destination, SettingsUI.Page>
    private let musicKitPermissionProvider: MusicKitPermissionProvider
    private let analyticsManager: AnalyticsManager

    public init(
        router: Router<SettingsUI.Destination, SettingsUI.Page>,
        musicKitPermissionProvider: MusicKitPermissionProvider,
        analyticsManager: AnalyticsManager
    ) {
        self.router = router
        self.musicKitPermissionProvider = musicKitPermissionProvider
        self.analyticsManager = analyticsManager
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
            extrasSection
        }
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

//
//  SettingsView.swift
//  SettingsUI
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import EraGuessUI
import Permission
import SharedUI
import SwiftUI
import UINavigation

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    private let router: Router<SettingsUI.Destination, SettingsUI.Page>
    private let musicKitPermissionProvider: MusicKitPermissionProvider

    public init(
        router: Router<SettingsUI.Destination, SettingsUI.Page>,
        musicKitPermissionProvider: MusicKitPermissionProvider
    ) {
        self.router = router
        self.musicKitPermissionProvider = musicKitPermissionProvider
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

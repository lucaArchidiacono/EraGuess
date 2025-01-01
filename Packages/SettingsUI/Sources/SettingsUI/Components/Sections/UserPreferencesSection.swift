//
//  UserPreferencesSection.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Permission
import SwiftUI

struct UserPreferencesSection: View {
    @Environment(\.musicKitPermissionProvider) private var musicKitPermissionProvider

    var body: some View {
        Section {
            MusicKitNavigationButton(
                musicKitPermissionProvider: musicKitPermissionProvider
            )

            AppLanguageNavigationButton()
        } footer: {
            Text("""
            You can change the language of the app and give permission to access Apple Music.
            No worries, you do not need to have an Apple Music subscription.
            """)
        }
    }
}

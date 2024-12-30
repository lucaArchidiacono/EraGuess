//
//  UserPreferencesSection.swift
//  SettingsUI
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import Foundation
import Permission
import SwiftUI

struct UserPreferencesSection: View {
    public let musicKitPermissionProvider: MusicKitPermissionProvider

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

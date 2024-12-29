//
//  AppLanguageNavigationButton.swift
//  SettingsFeature
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import EraGuessShared
import SharedUI
import SwiftUI

struct AppLanguageNavigationButton: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        if let appLanguage = Locale.current.appLanguage {
            navigationButton(using: appLanguage)
                .buttonStyle(.plain)
        }
    }

    private func navigationButton(using appLanguage: String) -> some View {
        Button {
            openURL(EraGuessShared.appSettingsURL)
        } label: {
            HStack {
                NavigationText("Language")

                Spacer()
                HStack {
                    Text(appLanguage)
                        .foregroundStyle(.secondary)
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

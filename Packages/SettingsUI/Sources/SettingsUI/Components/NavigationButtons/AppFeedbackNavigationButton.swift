//
//  AppFeedbackNavigationButton.swift
//  SettingsFeature
//
//  Created by Luca Archidiacono on 25.12.2024.
//

import EraGuessShared
import SwiftUI

struct AppFeedbackNavigationButton: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        navigationButton
            .buttonStyle(.plain)
    }

    private var navigationButton: some View {
        Button {
            openURL(EraGuessShared.appFeedbackURL)
        } label: {
            HStack {
                Label(
                    title: {
                        Text("Leave a Review")
                            .fontWeight(.bold)
                    },
                    icon: {
                        Image(systemName: "star")
                            .foregroundStyle(.gray)
                    }
                )
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.gray)
            }
            .contentShape(.interaction, Rectangle())
        }
    }
}

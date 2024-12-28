//
//  OnboardingView.swift
//
//
//  Created by Luca Archidiacono on 09.05.2024.
//

import AnalyticsDomain
import Foundation
import Models
import Permission
import StateFeature
import SwiftUI

@MainActor
public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex: Int = 0
    @State private var pageConfigs: [OnboardingPageConfig] = []
    @State private var hasSeenOnboarding: Bool = false

    private let userPreferencesManager: UserPreferencesManager
    private let analyticsManager: AnalyticsManager
    private let notificationPermissionProvider: NotificationPermissionProvider

    private let onDismiss: () -> Void

    public init(
        userPrereferencesManager: UserPreferencesManager,
        analyticsManager: AnalyticsManager,
        notificationPermissionProvider: NotificationPermissionProvider,
        onDismiss: @escaping () -> Void
    ) {
        userPreferencesManager = userPrereferencesManager
        self.analyticsManager = analyticsManager
        self.notificationPermissionProvider = notificationPermissionProvider
        self.onDismiss = onDismiss
    }

    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0 ..< pageConfigs.count, id: \.self) { index in
                OnboardingPage(config: pageConfigs[index])
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: hasSeenOnboarding) { _, newValue in
            guard newValue else { return }
            onDismiss()
            dismiss()
        }
        .onAppear {
            analyticsManager.track(
                event: .view(
                    name: String(describing: OnboardingView.self)
                )
            )
            setup()
        }
    }
}

extension OnboardingView {
    private func setup() {
        setupOnboardingPages()
    }

    private func setupOnboardingPages() {
        let firstPage = OnboardingPageConfig(
            title: "Welcome to EraGuess!",
            bulletPoints: [
                .init(
                    imageName: "music.note",
                    title: "Play music and guess the era",
                    description: """
                    Listen to the music and guess the era it was released in.
                    """
                ),
                .init(
                    imageName: "person.3.sequence.fill",
                    title: "Single or multiplayer",
                    description: """
                    Play with multiple friends or by yourself.
                    """
                ),
            ],
            buttonTitle: "Continue",
            onAction: goToNextPage(using:)
        )

        pageConfigs.append(firstPage)

        let secondPage = OnboardingPageConfig(
            title: "Select your Music Player",
            bulletPoints: [
                .init(
                    imageName: "music.quarternote.3",
                    title: "Choose your preferred music service",
                    description: """
                    Select your preferred music service to play music.
                    """
                ),
            ],
            selections: MusicService.allCases.map { $0 as AnyHashable },
            onSelection: { selection in
                if let musicService = selection as? MusicService {
                    userPreferencesManager.$preferredMusicService.withLock { $0 = musicService }
                }
            },
            buttonTitle: "Get Started",
            onAction: { completion in
                guard let musicService = userPreferencesManager.preferredMusicService else {
                    return
                }

                switch musicService {
                case .appleMusic:
                    print("Setup Apple Music")
                case .spotify:
                    print("Setup Spotify")
                }

                hasSeenOnboarding = true
                goToNextPage(using: completion)
            }
        )

        pageConfigs.append(secondPage)
    }

    private func goToNextPage(using completion: @escaping () -> Void) {
        completion()

        guard pageConfigs.count > currentIndex else { return }

        currentIndex += 1
    }
}

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
import SwiftUI

@MainActor
public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex: Int = 0
    @State private var pageConfigs: [OnboardingPageConfig] = []
    @State private var hasSeenOnboarding: Bool = false

    private let analyticsManager: AnalyticsManager
    private let notificationPermissionProvider: NotificationPermissionProvider

    private let onDismiss: () -> Void

    public init(
        analyticsManager: AnalyticsManager,
        notificationPermissionProvider: NotificationPermissionProvider,
        onDismiss: @escaping () -> Void
    ) {
        self.analyticsManager = analyticsManager
        self.notificationPermissionProvider = notificationPermissionProvider
        self.onDismiss = onDismiss
    }

    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0 ..< pageConfigs.count, id: \.self) { index in
                OnboardingPage(config: pageConfigs[index])
                    .gesture(DragGesture())
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
        let welcomePage = OnboardingPageConfig(
            title: "Welcome to EraGuess!",
            bulletPoints: [
                .init(
                    imageName: "music.note",
                    title: "Play music and guess the era",
                    description: """
                    Listen to a preview of the music and guess the year it was released in.
                    """
                ),
                .init(
                    imageName: "person.3.sequence.fill",
                    title: "Single or multiplayer",
                    description: """
                    Play with multiple friends or by yourself.
                    """
                ),
                .init(
                    imageName: "trophy.fill",
                    title: "Compete and earn points",
                    description: """
                    Earn points by correctly guessing the year, artist name, and song title.
                    """
                ),
            ],
            buttonTitle: "Continue",
            onAction: goToNextPage(using:)
        )
        pageConfigs.append(welcomePage)

        let rulesPage = OnboardingPageConfig(
            title: "How to Play",
            bulletPoints: [
                .init(
                    imageName: "play.circle.fill",
                    title: "Listen to the Preview",
                    description: """
                    Each round starts with a short preview of a song. Pay attention to the style and sound!
                    """
                ),
                .init(
                    imageName: "calendar",
                    title: "Place on Timeline",
                    description: """
                    Place the song on the timeline between two reference tracks. The closer you get to the actual release year, the more points you earn.
                    """
                ),
                .init(
                    imageName: "music.mic",
                    title: "Bonus Points",
                    description: """
                    Get extra points by correctly guessing the artist's name and song title.
                    """
                ),
                .init(
                    imageName: "checkmark.circle.fill",
                    title: "Win the Game",
                    description: """
                    First player to correctly guess 10 songs wins! Incorrect guesses don't count towards your progress.
                    """
                ),
                .init(
                    imageName: "arrow.triangle.2.circlepath",
                    title: "Taking Turns",
                    description: """
                    Players take turns guessing. If you guess incorrectly, the song is discarded and it's the next player's turn.
                    """
                ),
            ],
            buttonTitle: "Let's Play",
            onAction: goToNextPage(using:)
        )
        pageConfigs.append(rulesPage)
    }

    private func goToNextPage(using completion: @escaping () -> Void) {
        completion()

        guard pageConfigs.count - 1 > currentIndex else {
            hasSeenOnboarding = true
            return
        }

        currentIndex += 1
    }
}

//
//  OnboardingView.swift
//
//
//  Created by Luca Archidiacono on 09.05.2024.
//

import AnalyticsDomain
import FAQUI
import Foundation
import Models
import Permission
import SharedUI
import SwiftUI

@MainActor
public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex: Int = 0
    @State private var infoConfigs: [AppleInfoConfig] = []
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
            ForEach(0 ..< infoConfigs.count, id: \.self) { index in
                AppleInfoView(config: infoConfigs[index])
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
        let welcomePage = AppleInfoConfig(
            title: "Welcome to EraGuess!",
            bulletPoints: [
                .init(
                    icon: .system(name: "music.note"),
                    title: "Play music and guess the era",
                    description: """
                    Listen to a preview of the music and guess the year it was released in.
                    """
                ),
                .init(
                    icon: .system(name: "person.3.sequence.fill"),
                    title: "Single or multiplayer",
                    description: """
                    Play with multiple friends or by yourself.
                    """
                ),
                .init(
                    icon: .system(name: "trophy.fill"),
                    title: "Compete and earn points",
                    description: """
                    Earn points by correctly guessing the year, artist name, and song title.
                    """
                ),
            ],
            buttonTitle: "Continue",
            onAction: goToNextPage(using:)
        )
        infoConfigs.append(welcomePage)

        let faqPage = FAQView.appleInfoConfig(
            buttonTitle: "Let's Play",
            onAction: goToNextPage(using:)
        )
        infoConfigs.append(faqPage)
    }

    private func goToNextPage(using completion: @escaping () -> Void) {
        completion()

        guard infoConfigs.count - 1 > currentIndex else {
            hasSeenOnboarding = true
            return
        }

        currentIndex += 1
    }
}

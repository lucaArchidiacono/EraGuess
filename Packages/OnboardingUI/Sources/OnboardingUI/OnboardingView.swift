//
//  OnboardingView.swift
//
//
//  Created by Luca Archidiacono on 09.05.2024.
//

import AnalyticsDomain
import ConfettiSwiftUI
import FAQUI
import Foundation
import Models
import Permission
import SharedUI
import StateFeature
import SwiftUI

private enum OnboardingPages {
    case welcome
    case faq
    case finish
}

@MainActor
public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex: Int = 0
    @State private var pages: [OnboardingPages] = [.welcome, .faq, .finish]
    @State private var isFinished: Bool = false

    private let appState: AppStateManager
    private let analyticsManager: AnalyticsManager
    private let notificationPermissionProvider: NotificationPermissionProvider

    public init(
        appState: AppStateManager,
        analyticsManager: AnalyticsManager,
        notificationPermissionProvider: NotificationPermissionProvider
    ) {
        self.appState = appState
        self.analyticsManager = analyticsManager
        self.notificationPermissionProvider = notificationPermissionProvider
    }

    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0 ..< pages.count, id: \.self) { index in
                Group {
                    switch pages[index] {
                    case .welcome:
                        welcomePage()
                    case .faq:
                        faqPage()
                    case .finish:
                        finishPage()
                    }
                }
                .padding(.top, 50)
                .gesture(DragGesture())
            }
        }
        .confettiCannon(trigger: .constant(isFinished))
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            analyticsManager.track(
                event: .view(
                    name: String(describing: OnboardingView.self)
                )
            )
        }
    }
}

extension OnboardingView {
    private func welcomePage() -> some View {
        AppleInfoView(
            config: .init(
                title: "Welcome to EraGuess!",
                buttonTitle: "Continue",
                onAction: goToNextPage
            ),
            bulletPoints: {
                IconBulletPoint(
                    config: .init(
                        icon: .system(name: "music.note"),
                        title: "Play music and guess the era",
                        description: """
                        Listen to a preview of the music and guess the year it was released in.
                        """
                    )
                )
                IconBulletPoint(
                    config: .init(
                        icon: .system(name: "person.3.sequence.fill"),
                        title: "Single or multiplayer",
                        description: """
                        Play with multiple friends or by yourself.
                        """
                    )
                )
                IconBulletPoint(
                    config: .init(
                        icon: .system(name: "trophy.fill"),
                        title: "Compete and earn points",
                        description: """
                        Earn points by correctly guessing the year.
                        """
                    )
                )
            }
        )
    }

    private func faqPage() -> some View {
        FAQView.appleInfoView(
            buttonTitle: "Let's Play",
            onAction: goToNextPage
        )
    }

    private func finishPage() -> some View {
        AppleInfoView(
            config: .init(
                title: "Hurray! You are ready for EraGuess!",
                buttonTitle: "Continue",
                onAction: { goToNextPage() }
            )
        )
        .task {
            while !appState.hasSeenOnboarding {
                try? await Task.sleep(for: .seconds(0.7))
                isFinished.toggle()
            }
        }
    }

    private func goToNextPage() {
        guard pages.count - 1 > currentIndex else {
            appState.$hasSeenOnboarding.withLock { $0 = true }
            dismiss()
            return
        }

        currentIndex += 1
    }
}

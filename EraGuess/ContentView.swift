//
//  ContentView.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import AnalyticsDomain
import EmailFeatureUI
import FAQUI
import GameUI
import HapticFeedbackFeature
import HomeUI
import OnboardingUI
import Permission
import Services
import SettingsUI
import StateFeature
import SwiftUI

struct ContentView: View {
    @State var navigationManager: NavigationManager

    let appStateManager: AppStateManager
    let analyticsManager: AnalyticsManager
    let notificationPermissionProvider: NotificationPermissionProvider
    let musicKitPermissionProvider: MusicKitPermissionProvider
    let hapticFeedbackManager: HapticFeedbackManager
    let catalogSongService: CatalogSongService
    let streamingServiceRepository: StreamingServiceRepository
    let userPreferencesManager: UserPreferencesManager

    var body: some View {
        appView
            .sheet(
                isPresented: .constant(!appStateManager.hasSeenOnboarding)
            ) {
                onboardingFeature
                    .interactiveDismissDisabled(true)
            }
    }

    private var appView: some View {
        homeFeature
    }
}

extension ContentView {
    private var onboardingFeature: some View {
        OnboardingView(
            analyticsManager: analyticsManager,
            notificationPermissionProvider: notificationPermissionProvider,
            onDismiss: {
                appStateManager.$hasSeenOnboarding.withLock { $0 = true }
            }
        )
    }
}

extension ContentView {
    private var homeFeature: some View {
        NavigationStack(path: $navigationManager.homeRouter.path) {
            HomeView(
                router: navigationManager.homeRouter,
                hapticFeedbackManager: hapticFeedbackManager,
                analyticsManager: analyticsManager
            )
            .navigationDestination(for: HomeUI.Destination.self, destination: handle(_:))
            .sheet(item: $navigationManager.homeRouter.sheet, content: handle(_:))
            .fullScreenCover(item: $navigationManager.homeRouter.fullScreen, content: handle(_:))
        }
    }

    @ViewBuilder
    private func handle(_ destination: HomeUI.Destination) -> some View {
        switch destination {
        case .unknown:
            EmptyView()
        }
    }

    @ViewBuilder
    private func handle(_ page: HomeUI.Page) -> some View {
        switch page {
        case .settings:
            settingsFeature
        case .subscription:
            EmptyView()
        case .game:
            gameFeature
        case .faq:
            faqFeature
        }
    }
}

extension ContentView {
    private var gameFeature: some View {
        NavigationStack {
            GameView(
                appStateManager: appStateManager,
                userPreferencesManager: userPreferencesManager,
                catalogSongService: catalogSongService,
                streamingServiceRepository: streamingServiceRepository,
                analyticsManager: analyticsManager
            )
        }
    }
}

extension ContentView {
    private var settingsFeature: some View {
        NavigationStack(path: $navigationManager.settingsRouter.path) {
            SettingsView(
                router: navigationManager.settingsRouter,
                musicKitPermissionProvider: musicKitPermissionProvider,
                analyticsManager: analyticsManager,
                userPreferencesManager: userPreferencesManager,
                appStateManager: appStateManager
            )
            .navigationDestination(for: SettingsUI.Destination.self, destination: handle(_:))
            .sheet(item: $navigationManager.settingsRouter.sheet, content: handle(_:))
            .fullScreenCover(item: $navigationManager.settingsRouter.fullScreen, content: handle(_:))
        }
    }

    @ViewBuilder
    private func handle(_ destination: SettingsUI.Destination) -> some View {
        switch destination {
        case .feedback:
            FeedbackView(
                router: navigationManager.settingsRouter,
                analyticsManager: analyticsManager
            )
        case .privacy:
            PrivacyView(
                analyticsManager: analyticsManager
            )
        case .termsOfUse:
            TermsOfUseView(
                analyticsManager: analyticsManager
            )
        }
    }

    @ViewBuilder
    private func handle(_ page: SettingsUI.Page) -> some View {
        switch page {
        case let .email(data):
            AppleMailView(
                emailData: data,
                analyticsManager: analyticsManager
            )
        }
    }
}

extension ContentView {
    private var faqFeature: some View {
        NavigationStack {
            FAQView(
                analyticsManager: analyticsManager
            )
        }
    }
}

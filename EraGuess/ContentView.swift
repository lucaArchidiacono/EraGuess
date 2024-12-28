//
//  ContentView.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import AnalyticsDomain
import HomeUI
import OnboardingUI
import Permission
import StateFeature
import SwiftUI

struct ContentView: View {
    @State var navigationManager: NavigationManager

    let appStateManager: AppStateManager
    let analyticsManager: AnalyticsManager
    let notificationPermissionProvider: NotificationPermissionProvider

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
                router: navigationManager.homeRouter
            )
        }
        .navigationDestination(for: HomeUI.Destination.self, destination: handle(_:))
        .sheet(item: $navigationManager.homeRouter.sheet, content: handle(_:))
        .fullScreenCover(item: $navigationManager.homeRouter.fullScreen, content: handle(_:))
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
            EmptyView()
        case .subscription:
            EmptyView()
        case .game:
            Text("Game")
        }
    }
}

//
//  ContentView.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import AnalyticsDomain
import OnboardingUI
import Permission
import StateFeature
import SwiftUI

struct ContentView: View {
    let dependencyProvider: DependencyProviding

    private var appStateManager: AppStateManager { dependencyProvider.appStateManager }
    private var analyticsManager: AnalyticsManager { dependencyProvider.analyticsManager }
    private var notificationPermissionProvider: NotificationPermissionProvider { dependencyProvider.notificationPermissionProvider }

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
        Text("Hello, world!")
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

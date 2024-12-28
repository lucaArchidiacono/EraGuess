//
//  ContentView.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import OnboardingUI
import SwiftUI

struct ContentView: View {
    let dependencyProvider: DependencyProviding

    @State private var showOnboarding: Bool = false

    var body: some View {
        appView
            .sheet(isPresented: $showOnboarding) {
                onboardingFeature
                    .interactiveDismissDisabled(true)
            }
            .onAppear {
                showOnboarding = !dependencyProvider.appStateManager.hasSeenOnboarding
            }
    }

    private var appView: some View {
        Text("Hello, world!")
    }
}

extension ContentView {
    private var onboardingFeature: some View {
        OnboardingView(
            userPrereferencesManager: dependencyProvider.userPreferenceManager,
            analyticsManager: dependencyProvider.analyticsManager,
            notificationPermissionProvider: dependencyProvider.notificationPermissionProvider,
            onDismiss: {
                dependencyProvider.appStateManager.$hasSeenOnboarding.withLock { $0 = true }
                showOnboarding = false
            }
        )
    }
}

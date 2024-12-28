//
//  EraGuessApp.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import Logger
import SwiftUI

@main
struct EraGuessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    private let logger = Logger(label: String(describing: EraGuessApp.self))

    private var dependencyProvider: DependencyProvider {
        appDelegate.dependencyProvider
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                appStateManager: dependencyProvider.appStateManager,
                analyticsManager: dependencyProvider.analyticsManager,
                notificationPermissionProvider: dependencyProvider.notificationPermissionProvider
            )
            .onChange(of: scenePhase, initial: true) { _, newValue in
                handleScenePhase(newValue)
            }
        }
    }

    private func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .background:
            logger.debug("BACKGROUND")
        case .active:
            logger.debug("ACTIVE")
            dependencyProvider.analyticsManager.track(event: .state(.active))
        case .inactive:
            logger.debug("INACTIVE")
        @unknown default:
            fatalError("Case \(scenePhase) not handeled!")
        }
    }
}

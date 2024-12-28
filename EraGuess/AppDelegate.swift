//
//  AppDelegate.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import EraGuessShared
import Logger
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    private var logger: Logger!

    var dependencyProvider: DependencyProvider!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureLogging()
        configureDependencyProvider()
        return true
    }

    private func configureLogging() {
        var logBuilder = LogBuilder()
        logBuilder.addFileOutput(fileURL: EraGuessShared.Configuration.newLogFileURL(for: .mainApp))
        #if DEBUG
            logBuilder.addOSLogOutput(subsystem: EraGuessShared.Target.mainApp.bundleIdentifier)
        #endif
        logBuilder.install()

        logger = Logger(label: String(describing: AppDelegate.self))
    }

    private func configureDependencyProvider() {
        dependencyProvider = DependencyProvider()
    }
}

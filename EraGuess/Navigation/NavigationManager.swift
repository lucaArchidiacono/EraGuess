//
//  NavigationManager.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import HomeUI
import SettingsUI
import SwiftUI
import UINavigation

@MainActor
@Observable
final class NavigationManager {
    // MARK: - Routers

    var homeRouter = Router<HomeUI.Destination, HomeUI.Page>()
    var settingsRouter = Router<SettingsUI.Destination, SettingsUI.Page>()

    init() {}
}

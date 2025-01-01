//
//  LanguageSelectionCard.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 01.01.2025.
//

import SwiftUI
import Foundation
import Models
import EraGuessUI
import StateFeature

struct LanguageSelectionCard: View {
    @Environment(AppStateManager.self) private var appStateManager
    
    let languageSet: LanguageSet
    
    var body: some View {
        switch languageSet {
        case .enDE:
            SelectionCard(
                config: .init(
                    header: .text("🇺🇸🇩🇪"),
                    title: "English/German",
                    description: """
                    Listen to music from the US and Germany.    
                    """
                ),
                isSelected: appStateManager.availableLanguageSet.contains(languageSet),
                action: {
                    appStateManager.$availableLanguageSet.withLock { _ = $0.insert(languageSet) }
                }
            )
            .disabled(
                appStateManager.availableLanguageSet.contains(languageSet)
            )
        case .enCH:
            SelectionCard(
                config: .init(
                    header: .text("🇺🇸🇨🇭"),
                    title: "English/Swiss German",
                    description: "Coming Soon..."
                ),
                isSelected: false,
                action: {}
            )
            .disabled(true)
        }
    }
}

//
//  LanguageSetSection.swift
//  SettingsUI
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import Foundation
import SwiftUI
import EraGuessUI
import StateFeature
import Models

struct LanguageSetSection: View {
    @Environment(AppStateManager.self) private var appStateManager
    
    var body: some View {
        section
            .listRowBackground(Color.clear)
    }
    
    private var content: some View {
        ForEach(LanguageSet.allCases, id: \.self) { languageSet in
            selectionCard(languageSet)
                .listRowSeparator(.hidden)
        }
    }
    
    private var section: some View {
        Section {
            content
                .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
        } header: {
            Text("Language Set")
        }
    }
    
    @ViewBuilder
    private func selectionCard(_ languageSet: LanguageSet) -> some View {
        switch languageSet {
        case .enDe:
            SelectionCard(
                config: .init(
                    header: .text("🇺🇸🇩🇪"),
                    title: "English/German Music Pack",
                    description: """
                    Listen to music from the UK and Germany.    
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
        }
        SelectionCard(
            config: .init(
                header: .text("🇺🇸🇨🇭"),
                title: "English/Swiss German Music Pack",
                description: """
                    More Languages will be added soon...
                    """
            ),
            isSelected: false,
            action: {}
        )
        .disabled(true)
    }
}

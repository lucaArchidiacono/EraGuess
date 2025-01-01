//
//  LanguageSetSection.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import EraGuessUI
import Foundation
import Models
import StateFeature
import SwiftUI

struct LanguageSetSection: View {
    @Environment(AppStateManager.self) private var appStateManager

    var body: some View {
        section
            .listRowBackground(Color.clear)
    }

    private var content: some View {
        ForEach(LanguageSet.allCases, id: \.self) { languageSet in
            LanguageSelectionCard(
                languageSet: languageSet
            )
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
}

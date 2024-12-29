//
//  ExtrasSection.swift
//  SettingsFeature
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import SwiftUI

struct ExtrasSection: View {
    var body: some View {
        Section("Extras") {
            FeedbackNavigationButton()
            TermsOfUseNavigationButton()
            PrivacyNavigationButton()
        }
    }
}

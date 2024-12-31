//
//  TermsOfUseNavigationButton.swift
//  SettingsFeature
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import SharedUI
import SwiftUI
import UINavigation

struct TermsOfUseNavigationButton: View {
    @Environment(Router<Destination, Page>.self) private var router

    var body: some View {
        NavigationButton(
            title: "Terms of Use",
            image: {
                Image(systemName: "doc.plaintext")
            },
            action: {
                router.path.append(.termsOfUse)
            }
        )
    }
}

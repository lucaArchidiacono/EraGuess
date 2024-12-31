//
//  PrivacyNavigationButton.swift
//  SettingsFeature
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import SharedUI
import SwiftUI
import UINavigation

struct PrivacyNavigationButton: View {
    @Environment(Router<Destination, Page>.self) private var router

    var body: some View {
        NavigationButton(
            title: "Privacy Policy",
            image: {
                Image(systemName: "eyeglasses")
            },
            action: {
                router.path.append(.privacy)
            }
        )
    }
}

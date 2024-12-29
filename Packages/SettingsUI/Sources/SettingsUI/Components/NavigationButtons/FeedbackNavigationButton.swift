//
//  FeedbackNavigationButton.swift
//  SettingsFeature
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import SharedUI
import SwiftUI
import UINavigation

struct FeedbackNavigationButton: View {
    @Environment(Router<Destination, Page>.self) private var router

    var body: some View {
        NavigationButton(
            title: "Feedback & Support",
            image: {
                Image(systemName: "paperplane")
            },
            action: {
                router.path.append(.feedback)
            }
        )
    }
}

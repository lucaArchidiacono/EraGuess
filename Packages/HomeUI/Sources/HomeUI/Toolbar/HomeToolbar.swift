//
//  HomeToolbar.swift
//  HomeUI
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import Foundation
import Models
import SharedUI
import SwiftUI
import UINavigation

struct HomeToolbar: ToolbarContent {
    @Environment(Router<Destination, Page>.self) private var router: Router<Destination, Page>

    var body: some ToolbarContent {
        FAQToolbar(placement: .topBarTrailing) {
            router.sheet = .faq
        }

        SettingsToolbar(placement: .topBarTrailing) {
            router.sheet = .settings
        }
    }
}

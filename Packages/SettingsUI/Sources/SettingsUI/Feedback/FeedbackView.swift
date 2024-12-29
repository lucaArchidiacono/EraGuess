//
//  FeedbackView.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 05.05.2024.
//

import AnalyticsDomain
import EmailFeatureUI
import EraGuessShared
import Foundation
import SwiftUI
import UINavigation

@MainActor
public struct FeedbackView: View {
    @Environment(\.openURL) private var openURL

    private let router: Router<Destination, Page>
    private let analyticsManager: AnalyticsManager

    public init(
        router: Router<Destination, Page>,
        analyticsManager: AnalyticsManager
    ) {
        self.router = router
        self.analyticsManager = analyticsManager
    }

    public var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Feedback & Support")
            .onAppear {
                analyticsManager.track(
                    event: .view(
                        name: String(describing: FeedbackView.self)
                    )
                )
            }
    }

    private var content: some View {
        List {
            infoCard
            customerSupportSection
        }
    }

    private var infoCard: some View {
        GroupBox {
            Text("While I do read every message, as I’m just one person, I’m not able to respond to every one. I hope you understand, and thanks for your feedback.")
        } label: {
            HStack {
                Spacer()
                Text("Customer Support")
                Spacer()
            }
        }
        .backgroundStyle(Color.clear)
        .listRowInsets(EdgeInsets())
    }

    private var customerSupportSection: some View {
        Section {
            AppFeedbackNavigationButton()

            if AppleMailView.canSendMail {
                EmailFeedbackNavigationButton()
            }
        } header: {
            Text("Customer Support")
        } footer: {
            Text("If you don’t have a default email app configured, you can email me directly at \(EraGuessShared.email)")
        }
    }
}

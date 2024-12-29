//
//  TermsOfUseView.swift
//
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import AnalyticsDomain
import Foundation
import SwiftUI

public struct TermsOfUseView: View {
    private let analyticsManager: AnalyticsManager

    public init(
        analyticsManager: AnalyticsManager
    ) {
        self.analyticsManager = analyticsManager
    }

    public var body: some View {
        List {
            infoCard
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Terms of Use")
        .onAppear {}
    }

    private var infoCard: some View {
        GroupBox {
            Text("Use of EraGuess is governed by Apple’s Standard EULA for apps. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. Auto-renewal may be turned off by the user, by going to the user’s Account Settings after purchase. The duration and price of each subscription is displayed on the purchase screen, and updated at the time of purchase. If you have any questions about EraGuess Terms of Use, please reach out to me at support@eraguess.ch")
        } label: {
            HStack {
                Spacer()
                Text("Terms of Use")
                Spacer()
            }
        }
        .backgroundStyle(Color.clear)
        .listRowInsets(EdgeInsets())
    }
}

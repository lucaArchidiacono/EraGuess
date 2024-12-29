//
//  PrivacyView.swift
//
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import AnalyticsDomain
import SwiftUI

public struct PrivacyView: View {
    private let analyticsManager: AnalyticsManager

    public init(
        analyticsManager: AnalyticsManager
    ) {
        self.analyticsManager = analyticsManager
    }

    public var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Privacy Policy")
            .onAppear {
                analyticsManager.track(
                    event: .view(
                        name: String(describing: PrivacyView.self)
                    )
                )
            }
    }

    private var content: some View {
        List {
            infoCard
        }
    }

    private var infoCard: some View {
        GroupBox {
            Text("Your privacy matters. Your data won’t be collected or stored. What you do is your business, not ours or anyone else’s.")
        } label: {
            HStack {
                Spacer()
                Text("Privacy Policy")
                Spacer()
            }
        }
        .backgroundStyle(Color.clear)
        .listRowInsets(EdgeInsets())
    }
}

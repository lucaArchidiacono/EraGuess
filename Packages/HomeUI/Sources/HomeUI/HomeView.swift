//
//  HomeView.swift
//  HomeUI
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import AnalyticsDomain
import HapticFeedbackFeature
import SwiftUI
import UINavigation

public struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let router: Router<HomeUI.Destination, HomeUI.Page>
    private let analyticsManager: AnalyticsManager
    private let hapticFeedbackManager: HapticFeedbackManager

    public init(
        router: Router<HomeUI.Destination, HomeUI.Page>,
        hapticFeedbackManager: HapticFeedbackManager,
        analyticsManager: AnalyticsManager
    ) {
        self.router = router
        self.hapticFeedbackManager = hapticFeedbackManager
        self.analyticsManager = analyticsManager
    }

    public var body: some View {
        content
            .toolbar {
                HomeToolbar()
            }
            .environment(router)
            .onAppear {
                analyticsManager.track(
                    event: .view(
                        name: String(describing: HomeView.self)
                    )
                )
            }
    }

    private var content: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            VStack {
                Text("EraGuess")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 50)

                Spacer()

                VinylDisk(
                    hapticFeedbackManager: hapticFeedbackManager
                )
                .shadow(color: .black.opacity(0.3), radius: 20)

                Spacer()

                Text("Tap the vinyl to start a game")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark ?
                [Color(white: 0.1), Color(white: 0.2)] :
                [.white, Color(white: 0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

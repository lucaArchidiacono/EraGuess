//
//  HomeView.swift
//  HomeUI
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import SwiftUI
import UINavigation

public struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let router: Router<HomeUI.Destination, HomeUI.Page>

    public init(
        router: Router<HomeUI.Destination, HomeUI.Page>
    ) {
        self.router = router
    }

    public var body: some View {
        content
            .environment(router)
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

                VinylDisk()
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

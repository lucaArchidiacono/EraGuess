//
//  GameView.swift
//  GameUI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import AnalyticsDomain
import EraGuessUI
import Logger
import Models
import Services
import SharedUI
import StateFeature
import SwiftUI

public struct GameView: View {
    private let logger = Logger(label: String(describing: GameView.self))

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    @State private var appStateManager: AppStateManager
    @State private var userPreferencesManager: UserPreferencesManager
    @State private var engine: GameEngine = .init()

    private let catalogSongService: CatalogSongService
    private let streamingServiceRepository: StreamingServiceRepository
    private let analyticsManager: AnalyticsManager

    public init(
        appStateManager: AppStateManager,
        userPreferencesManager: UserPreferencesManager,
        catalogSongService: CatalogSongService,
        streamingServiceRepository: StreamingServiceRepository,
        analyticsManager: AnalyticsManager
    ) {
        _appStateManager = State(wrappedValue: appStateManager)
        _userPreferencesManager = State(wrappedValue: userPreferencesManager)

        self.catalogSongService = catalogSongService
        self.streamingServiceRepository = streamingServiceRepository
        self.analyticsManager = analyticsManager
    }

    public var body: some View {
        content
            .toolbar {
                CloseToolbar(placement: .topBarTrailing) {
                    dismiss()
                }
            }
            .environment(appStateManager)
            .environment(userPreferencesManager)
            .environment(engine)
            .onAppear {
                analyticsManager.track(
                    event: .view(
                        name: String(describing: GameView.self)
                    )
                )
            }
            .onChange(of: appStateManager.availableLanguageSet, initial: true) { _, newValue in
                Task {
                    let availableLanguageSets = LanguageSet.allCases.filter { newValue.contains($0) }
                    for availableLanguageSet in availableLanguageSets {
                        let newCatalogSongs = await catalogSongService.fetchCatalogSongs(for: availableLanguageSet)
                        engine.updateCatalogSongs(using: newCatalogSongs)
                    }
                }
            }
    }

    private func teardown() {
        Task {
            await streamingServiceRepository.stop()
        }
    }

    private var content: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            switch engine.state {
            case .setup:
                SetupView()
            case .finished:
                Text("Game Finished")
            case .playing:
                Text("Game playing")
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

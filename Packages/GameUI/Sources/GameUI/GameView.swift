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

    @State private var appStateManager: AppStateManager

    private let catalogSongService: CatalogSongService
    private let streamingService: StreamingService

    public init(
        appStateManager: AppStateManager,
        catalogSongService: CatalogSongService,
        streamingService: StreamingService
    ) {
        _appStateManager = State(wrappedValue: appStateManager)

        self.catalogSongService = catalogSongService
        self.streamingService = streamingService
    }

    public var body: some View {
        content
            .onDisappear {
                Task {}
            }
    }

    private var content: some View {
        List {
            selectionCards

            fetchSongCatalog

            songs
        }
    }

    @State private var selectedLanguageSet: LanguageSet?

    private var availableLanguageSet: [LanguageSet] {
        LanguageSet.allCases.filter { appStateManager.availableLanguageSet.contains($0) }
    }

    private var selectionCards: some View {
        ForEach(availableLanguageSet, id: \.self) { languageSet in
            SelectionCard(
                config: .init(
                    header: .text(languageSet.code),
                    title: "\(languageSet.localizedString) Language",
                    description: """
                    Listen to a preview of the music and guess the era it was released in.
                    """
                ),
                isSelected: languageSet == selectedLanguageSet,
                action: {
                    if languageSet == selectedLanguageSet {
                        selectedLanguageSet = nil
                    } else {
                        selectedLanguageSet = languageSet
                    }
                }
            )
        }
    }

    @State private var catalogSongs: [CatalogSong] = []

    private var fetchSongCatalog: some View {
        AsyncButton("Select Random Song") {
            guard let selectedLanguageSet else { return }
            let catalogSongs = await catalogSongService.fetchCatalogSongs(for: selectedLanguageSet)
            self.catalogSongs = catalogSongs
        }
        .disabled(selectedLanguageSet == nil)
    }

    private var songs: some View {
        ForEach(catalogSongs) { catalogSong in
            Button(catalogSong.title) {
                Task {
                    do {
                        if await streamingService.isPlaying {
                            try await streamingService.stop()
                        }

                        let streamableSongs = try await streamingService.searchSongs(query: catalogSong.title)
                        guard let streamableSong = streamableSongs.first else { return }
                        try await streamingService.play(song: streamableSong)
                    } catch {
                        logger.error("Failed to search songs: \(error)")
                    }
                }
            }
        }
    }
}

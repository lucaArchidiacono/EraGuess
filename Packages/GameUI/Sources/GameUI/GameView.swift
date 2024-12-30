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
    @Environment(\.dismiss) private var dismiss
    
    private let logger = Logger(label: String(describing: GameView.self))

    @State private var appStateManager: AppStateManager
    @State private var userPreferencesManager: UserPreferencesManager
    
    @State private var catalogSongs: [CatalogSong] = []
    @State private var playbackState: PlaybackState = .stopped

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
                TextToolbar("Done", placement: .topBarTrailing) {
                    dismiss()
                }
            }
            .onAppear {
                analyticsManager.track(
                    event: .view(
                        name: String(describing: GameView.self)
                    )
                )
            }
            .onDisappear {
                Task {
                    await streamingServiceRepository.stop()
                }
            }
            .task {
                while true {
                    playbackState = await streamingServiceRepository.playbackState
                    try? await Task.sleep(for: .seconds(1))
                }
            }
            .onChange(of: appStateManager.availableLanguageSet, initial: true) { _, newValue in
                Task {
                    let availableLanguageSets = LanguageSet.allCases.filter { newValue.contains($0) }
                    for availableLanguageSet in availableLanguageSets {
                        let newCatalogSongs = await catalogSongService.fetchCatalogSongs(for: availableLanguageSet)
                        catalogSongs.append(contentsOf: newCatalogSongs)
                    }
                }
            }
    }

    private var content: some View {
        VStack {
            list
            audioControls
        }
    }
    
    private var list: some View {
        List {
            songs
        }
    }

    private var songs: some View {
        ForEach(catalogSongs) { catalogSong in
            Button(catalogSong.title) {
                Task {
                    do {
                        playbackState = await streamingServiceRepository.playbackState
                        
                        if playbackState == .playing {
                            await streamingServiceRepository.stop()
                        }

                        let streamableSongs = try await streamingServiceRepository.searchSongs(catalogSong: catalogSong)
                        guard let streamableSong = streamableSongs.first else { return }
                        try await streamingServiceRepository.play(song: streamableSong)
                        playbackState = await streamingServiceRepository.playbackState
                    } catch {
                        logger.error("Failed to search songs: \(error)")
                    }
                }
            }
        }
    }
    

    private var audioControls: some View {
        HStack(spacing: 30) {
            // Play Button
            Button(action: {
                Task {
                    playbackState = await streamingServiceRepository.playbackState
                    
                    if playbackState == .paused {
                        await streamingServiceRepository.resume()
                    } else {
                        await streamingServiceRepository.pause()
                    }
                    
                    playbackState = await streamingServiceRepository.playbackState
                }
            }) {
                Image(systemName: playbackState == .playing ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                    .padding()
                    .shadow(radius: 5)
            }

            // Stop Button
            Button(action: {
                Task {
                    playbackState = await streamingServiceRepository.playbackState
                    
                    if playbackState == .playing {
                        await streamingServiceRepository.stop()
                    }
                    
                    playbackState = await streamingServiceRepository.playbackState
                }
            }) {
                Image(systemName: "stop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .padding()
                    .shadow(radius: 5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
}

//
//  StreamingServiceRepository.swift
//  Services
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import Logger
import Models

public struct StreamingServiceRepository: StreamingService, Sendable {
    private let logger = Logger(label: String(describing: StreamingServiceRepository.self))

    private let appleMusicService: AppleMusicService
    private let spotifyService: SpotifyService

    private let playerService: PlayerService

    public var isPlaying: Bool {
        get async {
            await playerService.getIsPlaying()
        }
    }

    public init(
        appleMusicService: AppleMusicService,
        spotifyService: SpotifyService,
        playerService: PlayerService
    ) {
        self.appleMusicService = appleMusicService
        self.spotifyService = spotifyService
        self.playerService = playerService
    }

    public func searchSongs(query: String) async throws -> [StreamableSong] {
        let appleMusicSongs = await searchSongsInAppleMusic(query: query)

        if !appleMusicSongs.isEmpty {
            return appleMusicSongs
        }

        let spotifySongs = await searchSongsInSpotify(query: query)

        if !spotifySongs.isEmpty {
            return spotifySongs
        }

        return []
    }

    private func searchSongsInAppleMusic(query: String) async -> [StreamableSong] {
        do {
            let songs = try await appleMusicService.searchSongs(query: query)
            return songs
        } catch {
            logger.error("Failed to search songs in Apple Music: \(error)")
            return []
        }
    }

    private func searchSongsInSpotify(query: String) async -> [StreamableSong] {
        do {
            let songs = try await spotifyService.searchSongs(query: query)
            return songs
        } catch {
            logger.error("Failed to search songs in Spotify: \(error)")
            return []
        }
    }

    public func play(song: StreamableSong) async throws {
        logger.trace("Playing song: \(song.title) by \(song.artist)")
        await playerService.play(url: song.previewURL)
    }

    public func pause() async {
        logger.trace("Pausing the player")
        await playerService.pause()
    }

    public func stop() async {
        logger.trace("Stopping the player")
        await playerService.stop()
    }
}
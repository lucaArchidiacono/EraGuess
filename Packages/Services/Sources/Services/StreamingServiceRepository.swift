//
//  StreamingServiceRepository.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Logger
import Models

public struct StreamingServiceRepository: StreamingService, Sendable {
    private let logger = Logger(label: String(describing: StreamingServiceRepository.self))

    private let appleMusicService: AppleMusicService
    private let spotifyService: SpotifyService

    private let playerService: PlayerService

    public var playbackState: PlaybackState {
        get async {
            await playerService.getPlaybackState()
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

    public func searchSongs(catalogSong: CatalogSong) async throws -> [StreamableSong] {
        let appleMusicSongs = await searchSongsInAppleMusic(catalogSong: catalogSong)

        if !appleMusicSongs.isEmpty {
            return appleMusicSongs
        }

        let spotifySongs = await searchSongsInSpotify(catalogSong: catalogSong)

        if !spotifySongs.isEmpty {
            return spotifySongs
        }

        return []
    }

    public func searchSongsInAppleMusic(catalogSong: CatalogSong) async -> [StreamableSong] {
        do {
            let songs = try await appleMusicService.searchSongs(catalogSong: catalogSong)
            return songs
        } catch {
            logger.error("Failed to search songs in Apple Music: \(error)")
            return []
        }
    }

    public func searchSongsInSpotify(catalogSong: CatalogSong) async -> [StreamableSong] {
        do {
            let songs = try await spotifyService.searchSongs(catalogSong: catalogSong)
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

    public func resume() async {
        logger.trace("Pausing the player")
        await playerService.resume()
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

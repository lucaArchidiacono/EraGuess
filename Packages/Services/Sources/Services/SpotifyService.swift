//
//  SpotifyService.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Logger
import Models

struct SpotifyService: StreamingService {
    private let logger = Logger(label: String(describing: SpotifyService.self))
    private let playerService: PlayerService

    public var isPlaying: Bool {
        get async {
            await playerService.getIsPlaying()
        }
    }

    public init(
        playerService: PlayerService
    ) {
        self.playerService = playerService
    }

    func searchSongs(query: String) async throws -> [StreamableSong] {
        logger.trace("Searching for songs with query: \(query)")
        let streamableSongs: [StreamableSong] = []
        logger.notice("Found \(streamableSongs.count) songs")
        return streamableSongs
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

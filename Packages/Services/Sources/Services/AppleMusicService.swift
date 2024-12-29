//
//  AppleMusicService.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Logger
import Models
import MusicKit

public struct AppleMusicService: StreamingService {
    private let logger = Logger(label: String(describing: AppleMusicService.self))

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

    public func searchSongs(query: String) async throws -> [StreamableSong] {
        logger.trace("Searching for songs with query: \(query)")
        var request = MusicCatalogSearchRequest(term: query, types: [Song.self])
        request.limit = 10

        let response = try await request.response()

        let streamableSongs: [StreamableSong] = response.songs.compactMap { song in
            guard let previewURL = song.previewAssets?.first?.url else {
                return nil
            }

            return StreamableSong(
                id: song.id.rawValue,
                title: song.title,
                artist: song.artistName,
                year: Calendar.current.component(.year, from: song.releaseDate ?? Date()),
                previewURL: previewURL
            )
        }

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

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

    public init() {}

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
}

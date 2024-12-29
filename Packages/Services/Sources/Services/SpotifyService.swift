//
//  SpotifyService.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Logger
import Models

public struct SpotifyService: StreamingService {
    private let logger = Logger(label: String(describing: SpotifyService.self))

    public init() {}

    public func searchSongs(query: String) async throws -> [StreamableSong] {
        logger.trace("Searching for songs with query: \(query)")
        let streamableSongs: [StreamableSong] = []
        logger.notice("Found \(streamableSongs.count) songs")
        return streamableSongs
    }
}

//
//  StreamingService.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Models

enum StreamingServiceError: Error {
    case notAuthorized
}

public protocol StreamingService: Sendable {
    func searchSongs(catalogSong: CatalogSong) async throws -> [StreamableSong]
}

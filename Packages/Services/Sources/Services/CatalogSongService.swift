//
//  CatalogSongService.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Logger
import Models

public protocol CatalogSongService: Sendable {
    func fetchCatalogSongs(for languageSet: LanguageSet) async -> [CatalogSong]
}

public struct CatalogSongServiceImpl: CatalogSongService {
    private let logger = Logger(label: String(describing: CatalogSongServiceImpl.self))
    private let store = CatalogSongStore()

    public init() {}

    public func fetchCatalogSongs(for languageSet: LanguageSet) async -> [CatalogSong] {
        logger.info("Fetching catalog songs for language set: \(languageSet)")

        let songs = await store.fetch(using: languageSet)

        logger.info("Fetched \(songs.count) catalog songs")

        return songs
    }
}

//
//  CatalogSongStore.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Logger
import Models

struct CatalogSongContainer: Codable {
    let payloads: [Payload]

    struct Payload: Codable {
        let id: Int
        let title: String
        let artist: String
        let year: Int
    }
}

actor CatalogSongStore {
    private let logger = Logger(label: String(describing: CatalogSongStore.self))

    private var languageSongs: [LanguageSet: [CatalogSong]] = [:]

    init() {}

    func fetch(using languageSet: LanguageSet) async -> [CatalogSong] {
        guard let url = Bundle.module.url(forResource: "\(languageSet.code)-Songs", withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            logger.error("Failed to load songs for language set: \(languageSet)")
            return []
        }

        do {
            let container = try JSONDecoder().decode(CatalogSongContainer.self, from: data)

            languageSongs[languageSet] = container.payloads.map { payload in
                CatalogSong(
                    id: "\(payload.id)",
                    title: payload.title,
                    artist: payload.artist,
                    year: payload.year,
                    lanugageSet: languageSet
                )
            }
        } catch {
            logger.error("Failed to decode songs: \(error)")
        }

        return languageSongs[languageSet] ?? []
    }
}

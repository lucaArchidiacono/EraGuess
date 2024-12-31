//
//  Song.swift
//  Models
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation

public protocol Song: Identifiable, Codable, Sendable {
    var id: String { get }
    var title: String { get }
    var artist: String { get }
    var year: Int { get }
}

public struct CatalogSong: Song {
    public let id: String
    public let title: String
    public let artist: String
    public let year: Int
    public let languageSet: LanguageSet

    public init(
        id: String,
        title: String,
        artist: String,
        year: Int,
        lanugageSet: LanguageSet
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.year = year
        languageSet = lanugageSet
    }
}

public struct StreamableSong: Song {
    public let id: String
    public let title: String
    public let artist: String
    public let year: Int
    public let previewURL: URL

    public init(
        id: String,
        title: String,
        artist: String,
        year: Int,
        previewURL: URL
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.year = year
        self.previewURL = previewURL
    }

    public init(
        _ item: StreamableSong,
        previewURL: URL
    ) {
        self.init(
            id: item.id,
            title: item.title,
            artist: item.artist,
            year: item.year,
            previewURL: previewURL
        )
    }
}

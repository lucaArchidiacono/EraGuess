//
//  GETTracksResponse.swift
//  SpotifyAPI
//
//  Created by Luca Archidiacono on 30.12.2024.
//

import Foundation

struct GETTracksResponse: Codable {
    let tracks: Tracks

    struct Tracks: Codable {
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [Item]

        struct Item: Codable {
            let album: Album
            let artists: [Artist]
            let externalUrls: ExternalUrls
            let href, id: String
            let isPlayable: Bool
            let name: String
            let popularity: Int
            let previewURL: String?

            enum CodingKeys: String, CodingKey {
                case album, artists
                case externalUrls = "external_urls"
                case href, id
                case isPlayable = "is_playable"
                case name, popularity
                case previewURL = "preview_url"
            }

            struct Album: Codable {
                let totalTracks: Int
                let externalUrls: ExternalUrls
                let href, id: String
                let name, releaseDate, releaseDatePrecision: String
                let artists: [Artist]

                enum CodingKeys: String, CodingKey {
                    case totalTracks = "total_tracks"
                    case externalUrls = "external_urls"
                    case href, id, name
                    case releaseDate = "release_date"
                    case releaseDatePrecision = "release_date_precision"
                    case artists
                }
            }

            struct Artist: Codable {
                let externalUrls: ExternalUrls
                let href, id, name: String

                enum CodingKeys: String, CodingKey {
                    case externalUrls = "external_urls"
                    case href, id, name
                }
            }
        }

        struct ExternalUrls: Codable {
            let spotify: String
        }
    }
}

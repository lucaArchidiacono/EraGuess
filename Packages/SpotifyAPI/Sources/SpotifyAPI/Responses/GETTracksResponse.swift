//
//  GETTracksResponse.swift
//  SpotifyAPI
//
//  Created by DG-SM-8669 on 30.12.2024.
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
            let availableMarkets: [String]
            let externalIDS: ExternalIDS
            let externalUrls: ExternalUrls
            let href, id: String
            let isPlayable: Bool
            let name: String
            let popularity: Int
            let previewURL: String?
            let trackNumber: Int
            let type, uri: String
            let isLocal: Bool

            enum CodingKeys: String, CodingKey {
                case album, artists
                case availableMarkets = "available_markets"
                case externalIDS = "external_ids"
                case externalUrls = "external_urls"
                case href, id
                case isPlayable = "is_playable"
                case name, popularity
                case previewURL = "preview_url"
                case trackNumber = "track_number"
                case type, uri
                case isLocal = "is_local"
            }
            
            struct Album: Codable {
                let albumType: String
                let totalTracks: Int
                let availableMarkets: [String]
                let externalUrls: ExternalUrls
                let href, id: String
                let name, releaseDate, releaseDatePrecision: String
                let type, uri: String
                let artists: [Artist]
                
                enum CodingKeys: String, CodingKey {
                    case albumType = "album_type"
                    case totalTracks = "total_tracks"
                    case availableMarkets = "available_markets"
                    case externalUrls = "external_urls"
                    case href, id, name
                    case releaseDate = "release_date"
                    case releaseDatePrecision = "release_date_precision"
                    case type, uri, artists
                }
            }
            
            struct Artist: Codable {
                let externalUrls: ExternalUrls
                let href, id, name, type: String
                let uri: String
                
                enum CodingKeys: String, CodingKey {
                    case externalUrls = "external_urls"
                    case href, id, name, type, uri
                }
            }
        }
        
        struct ExternalIDS: Codable {
            let isrc: String
            let ean: String?
            let upc: String?
        }
        
        struct ExternalUrls: Codable {
            let spotify: String
        }
    }
}

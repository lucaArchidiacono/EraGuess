//
//  GETTracksRequest.swift
//  SpotifyAPI
//
//  Created by DG-SM-8669 on 30.12.2024.
//

import Foundation
import REST

struct GETTracksRequest: Request {
    var baseURL: URL? = URL(string: "https://api.spotify.com")
    var path: String? { "/v1/search" }
    var body: HTTPBody { .empty }
    var method: HTTPMethod { .get }

    var header: [String: Any] {
        ["Authorization": "Bearer \(token)"]
    }

    var queryItems: [URLQueryItem]? {
        var queryItems: [URLQueryItem] = []
        let query = "track:\(track) artist:\(artist)"
        queryItems.append(URLQueryItem(name: "q", value: query))
        queryItems.append(URLQueryItem(name: "type", value: "track"))
        queryItems.append(URLQueryItem(name: "market", value: "CH"))
        queryItems.append(URLQueryItem(name: "include_external", value: "audio"))
        return queryItems
    }

    private let token: String
    private let track: String
    private let artist: String

    init(
        token: String,
        track: String,
        artist: String
    ) {
        self.token = token
        self.track = track
        self.artist = artist
    }
}

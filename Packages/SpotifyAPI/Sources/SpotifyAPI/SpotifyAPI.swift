//
//  SpotifyAPI.swift
//  SpotifyAPI
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import Foundation
import Logger
import Models
import REST

public protocol SpotifyAPI: Sendable {
    func authenticate(clientId: String, clientSecret: String) async throws -> String
    func search(using token: String, track: String, artist: String) async throws -> [StreamableSong]
}

public struct SpotifyAPIImpl: SpotifyAPI {
    private let logger = Logger(label: String(describing: SpotifyAPI.self))
    private let network: REST

    public init(
        network: REST
    ) {
        self.network = network
    }

    public func authenticate(clientId: String, clientSecret: String) async throws -> String {
        logger.trace("Authenticating with clientID: \(clientId) & clientSecret: \(clientSecret)")
        let request = POSTAuthenticationRequest(
            clientId: clientId,
            clientSecret: clientSecret
        )

        let response: POSTAuthenticationResponse = try await network.request(request: request)
        logger.notice("Successfully authenticated with Spotify")
        return response.accessToken
    }

    public func search(
        using token: String,
        track: String,
        artist: String
    ) async throws -> [StreamableSong] {
        logger.trace("Searching tracks with track: \(track), artist: \(artist)")
        let request = GETTracksRequest(
            token: token,
            track: track,
            artist: artist
        )
        let response: GETTracksResponse = try await network.request(request: request)
        logger.notice("Successfully fetched tracks")
        return []
    }
}

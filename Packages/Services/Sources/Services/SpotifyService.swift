//
//  SpotifyService.swift
//  Services
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Logger
import Models
import SpotifyAPI

// Helper enum for authentication results
private enum AuthenticationResult {
    case token(String)
    case waiting
    case shouldAuthenticate
}

private actor SpotifyAuthenticator {
    enum State {
        case authenticated(token: String)
        case unauthenticated
        case inProgress
        case error(Error)
    }

    private var state: State = .unauthenticated

    // Remove individual get/update methods
    // Instead, provide atomic operations

    func authenticateIfNeeded() async -> AuthenticationResult {
        switch state {
        case let .authenticated(token):
            return .token(token)

        case .inProgress:
            return .waiting

        case .unauthenticated, .error:
            state = .inProgress
            return .shouldAuthenticate
        }
    }

    func updateWithToken(_ token: String) {
        state = .authenticated(token: token)
    }

    func updateWithError(_ error: Error) {
        state = .error(error)
    }

    func reset() {
        state = .unauthenticated
    }
}

public struct SpotifyService: StreamingService {
    private let logger = Logger(label: String(describing: SpotifyService.self))
    private let authenticator = SpotifyAuthenticator()
    private let api: SpotifyAPI

    private let clientId: String
    private let clientSecret: String

    public init(
        clientId: String,
        clientSecret: String,
        api: SpotifyAPI
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.api = api
    }

    public func searchSongs(catalogSong: CatalogSong) async throws -> [StreamableSong] {
        let token = try await getValidToken()
        logger.trace("Searching for songs with: \(catalogSong)")
        let streamableSongs = try await api.search(
            using: token,
            track: catalogSong.title,
            artist: catalogSong.artist
        )
        logger.notice("Found \(streamableSongs.count) songs")
        return streamableSongs
    }

    private func getValidToken() async throws -> String {
        while true {
            // Get authentication status and potentially initiate authentication atomically
            let result = await authenticator.authenticateIfNeeded()

            switch result {
            case let .token(token):
                return token

            case .waiting:
                // Wait a bit and try again
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                continue

            case .shouldAuthenticate:
                // We're the chosen one to perform authentication
                do {
                    let token = try await authenticate()
                    await authenticator.updateWithToken(token)
                    return token
                } catch {
                    await authenticator.updateWithError(error)
                    throw error
                }
            }
        }
    }

    private func authenticate() async throws -> String {
        logger.trace("Authenticating with Spotify")
        let token = try await api.authenticate(clientId: clientId, clientSecret: clientSecret)
        logger.notice("Authenticated with Spotify")
        return token
    }
}

//
//  SpotifyAPI.swift
//  SpotifyAPI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Logger
import Models
import REST
import SwiftSoup

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
        logger.debug("Authenticating with clientID: \(clientId) & clientSecret: \(clientSecret)")
        let request = POSTAuthenticationRequest(
            clientId: clientId,
            clientSecret: clientSecret
        )

        let response: POSTAuthenticationResponse = try await network.request(request: request)
        return response.accessToken
    }

    public func search(
        using token: String,
        track: String,
        artist: String
    ) async throws -> [StreamableSong] {
        logger.debug("Searching tracks with track: \(track), artist: \(artist)")
        let request = GETTracksRequest(
            token: token,
            track: track,
            artist: artist
        )
        let response: GETTracksResponse = try await network.request(request: request)
        let transformedResponses = DataTransformer.transform(response)

        let results: [StreamableSong] = await withTaskGroup(of: StreamableSong?.self, returning: [StreamableSong].self) { group in
            for transformedResponse in transformedResponses {
                group.addTask {
                    guard let (data, _) = try? await network.request(url: transformedResponse.previewURL) else { return nil }

                    let html = String(data: data, encoding: .utf8) ?? ""

                    guard let document = try? SwiftSoup.parse(html),
                          let metaTag = try? document.select("meta[property=og:audio]").first(),
                          let audioURL = try? metaTag.attr("content"),
                          let previewURL = URL(string: audioURL)
                    else { return nil }

                    return StreamableSong(transformedResponse, previewURL: previewURL)
                }
            }

            var results = [StreamableSong]()

            for await result in group where result != nil {
                results.append(result!)
            }
            return results
        }

        return results
    }
}

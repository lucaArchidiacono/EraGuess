//
//  StreamingService.swift
//  Services
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import Models

enum StreamingServiceError: Error {
    case notAuthorized
}

public protocol StreamingService: Sendable {
    var isPlaying: Bool { get async }
    func searchSongs(query: String) async throws -> [StreamableSong]
    func play(song: StreamableSong) async throws
    func pause() async throws
    func stop() async throws
}

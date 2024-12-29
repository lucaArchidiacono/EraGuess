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
    func searchSongs(query: String) async throws -> [StreamableSong]
}

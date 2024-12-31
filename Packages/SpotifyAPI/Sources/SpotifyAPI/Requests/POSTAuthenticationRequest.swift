//
//  POSTAuthenticationRequest.swift
//  SpotifyAPI
//
//  Created by Luca Archidiacono on 30.12.2024.
//

import Foundation
import REST

struct POSTAuthenticationRequest: Request {
    var baseURL: URL? = URL(string: "https://accounts.spotify.com")
    var path: String? { "/api/token" }
    var method: HTTPMethod { .post }

    var body: HTTPBody {
        .dictionary(["grant_type": "client_credentials"], .url)
    }

    var header: [String: Any] {
        let credentials = "\(clientId):\(clientSecret)".data(using: .utf8)!.base64EncodedString()
        return ["Authorization": "Basic \(credentials)"]
    }

    var queryItems: [URLQueryItem]? { nil }

    private let clientId: String
    private let clientSecret: String

    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}

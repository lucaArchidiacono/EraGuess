//
//  POSTAuthenticationResponse.swift
//  SpotifyAPI
//
//  Created by Luca Archidiacono on 30.12.2024.
//

import Foundation

struct POSTAuthenticationResponse: Codable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

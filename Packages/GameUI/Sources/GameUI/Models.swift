//
//  Models.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import Models

struct Team: Identifiable {
    let id: String
    let name: String
    let score: Int
    let catalogSongs: [CatalogSong]

    public init(
        id: String,
        name: String
    ) {
        self.id = id
        self.name = name
        score = 0
        catalogSongs = []
    }
}

enum TeamType {
    case human(Team)
    case bot(Team)
}

enum GameState {
    case playing
    case setup
    case finished
}

enum GameMode {
    case singlePlayer
    case multiplayer
}

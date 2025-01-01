//
//  GameEngine.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import Models
import SwiftUI

@MainActor
@Observable
final class GameEngine {
    private(set) var teams: [TeamType] = []
    private(set) var state: GameState = .setup
    private(set) var mode: GameMode = .singlePlayer
    private(set) var catalogSongs: [CatalogSong] = []

    let minTeams = 2
    let maxTeams = 4

    init() {
        setMode(.singlePlayer)
    }

    func startGame() {
        guard state != .playing else { return }

        self.state = .playing
    }

    func setMode(_ mode: GameMode) {
        guard state == .setup else { return }

        switch mode {
        case .singlePlayer:
            setupSinglePlayer()
        case .multiplayer:
            setupMultiPlayer()
        }
    }

    func setTeams(_ count: Int) {
        guard state == .setup else { return }

        if count == 0 {
            teams = []
        } else if count == 1 {
            let human = Team(id: "1", name: "Player")
            let bot = Team(id: "2", name: "Bot")
            teams = [
                .human(human),
                .bot(bot),
            ]
        } else if count <= maxTeams {
            teams = (0 ..< count).map { .human(Team(id: "\($0 + 1)", name: "Team \($0 + 1)")) }
        }
    }

    func updateCatalogSongs(using catalogSongs: [CatalogSong]) {
        guard state == .setup else { return }
        self.catalogSongs = catalogSongs
    }

    private func setupSinglePlayer() {
        guard state == .setup else { return }

        mode = .singlePlayer
        setTeams(1)
    }

    private func setupMultiPlayer() {
        guard state == .setup else { return }

        mode = .multiplayer
        setTeams(0)
    }
}

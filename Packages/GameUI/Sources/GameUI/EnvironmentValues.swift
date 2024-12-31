//
//  EnvironmentValues.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import SwiftUI

private struct TeamsKey: EnvironmentKey {
    static let defaultValue: [TeamType] = []
}

private struct GameStateKey: EnvironmentKey {
    static let defaultValue: GameState = .setup
}

private struct GameModeKey: EnvironmentKey {
    static let defaultValue: GameMode = .singlePlayer
}

extension EnvironmentValues {
    var teams: [TeamType] {
        get { self[TeamsKey.self] }
        set { self[TeamsKey.self] = newValue }
    }

    var state: GameState {
        get { self[GameStateKey.self] }
        set { self[GameStateKey.self] = newValue }
    }

    var mode: GameMode {
        get { self[GameModeKey.self] }
        set { self[GameModeKey.self] = newValue }
    }
}

//
//  GameModeButton.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

struct GameModeButton: View {
    @Environment(GameEngine.self) private var engine
    @Environment(\.hapticFeedbackManager) private var hapticFeedbackManager
    
    let mode: GameMode

    private var isSelected: Bool {
        engine.mode == mode
    }
    
    var body: some View {
        Button {
            hapticFeedbackManager.fireHaptic(of: .buttonPress)
            
            withAnimation {
                engine.setMode(mode)
            }
        } label: {
            VStack(spacing: 12) {
                Image(systemName: mode == .singlePlayer ? "person.fill" : "person.3.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(isSelected ? .white : .primary)

                Text(mode == .singlePlayer ? "Single Player" : "Multiplayer")
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(width: 160, height: 160)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? .blue : Color(.systemBackground))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(isSelected ? .clear : .gray.opacity(0.3), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
        }
    }
}

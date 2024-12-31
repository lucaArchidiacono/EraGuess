//
//  GameModeButton.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

struct GameModeButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 40))
                    .foregroundStyle(isSelected ? .white : .primary)

                Text(title)
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

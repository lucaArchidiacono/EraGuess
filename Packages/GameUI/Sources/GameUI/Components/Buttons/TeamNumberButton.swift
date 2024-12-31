//
//  TeamNumberButton.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

struct TeamNumberButton: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("\(number)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(isSelected ? .white : .primary)

                Text(number == 1 ? "Team" : "Teams")
                    .font(.subheadline)
                    .foregroundStyle(isSelected ? .white : .secondary)
            }
            .frame(width: 100, height: 100)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .blue : Color(.systemBackground))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? .clear : .gray.opacity(0.3), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
        }
    }
}

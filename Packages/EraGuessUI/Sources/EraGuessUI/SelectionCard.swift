//
//  SelectionCard.swift
//  EraGuessUI
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import SwiftUI

struct SelectionCardConfig {
    let imageName: String
    let title: String
    let description: String
}

struct SelectionCard: View {
    let config: SelectionCardConfig
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        Image(config.imageName, bundle: .module)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.primary)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.white, .green)
                                .font(.title3)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(config.title)
                            .font(.headline)

                        Text(config.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(isSelected ? .green : .gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
        }
        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
    }
}

import Models

#Preview {
    HStack {
        Spacer()
        SelectionCard(
            config: .init(
                imageName: "Spotify",
                title: "Spotfiy",
                description: "Select Spotify if you have a subscription or want to use the free version."
            ),
            isSelected: true,
            action: {}
        )
        Spacer()
    }
}

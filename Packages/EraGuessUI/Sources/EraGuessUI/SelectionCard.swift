//
//  SelectionCard.swift
//  EraGuessUI
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import SwiftUI

public struct SelectionCardConfig {
    public enum Header {
        case text(String)
        case image(Image)
    }

    let header: Header?
    let title: String
    let description: String

    public init(
        header: Header? = nil,
        title: String,
        description: String
    ) {
        self.header = header
        self.title = title
        self.description = description
    }
}

public struct SelectionCard: View {
    let config: SelectionCardConfig
    let isSelected: Bool
    let action: () -> Void

    public init(
        config: SelectionCardConfig,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.config = config
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        if let header = config.header {
                            switch header {
                            case let .text(string):
                                Text(string)
                                    .font(.headline)
                            case let .image(image):
                                image
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(.primary)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            }
                        }

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
                            .font(.title3)

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
    List {
        SelectionCard(
            config: .init(
                header: .text("DE-EN"),
                title: "English/German Music",
                description: "Listen to a preview of the music and guess the era it was released in."
            ),
            isSelected: true,
            action: {}
        )
        .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
}

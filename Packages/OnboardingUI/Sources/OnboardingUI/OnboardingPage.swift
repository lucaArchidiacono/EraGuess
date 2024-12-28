//
//  OnboardingPage.swift
//  OnboardingFeature
//
//  Created by Luca Archidiacono on 16.09.2024.
//

import Foundation
import Models
import SwiftUI

struct OnboardingPageConfig {
    let title: String
    let bulletPoints: [OnboardingBulletPointConfig]
    var selections: [AnyHashable?] = []
    var onSelection: ((AnyHashable?) -> Void)?
    let buttonTitle: String
    let onAction: (@escaping () -> Void) -> Void
}

struct OnboardingPage: View {
    @State private var isLoading: Bool = false
    @State private var selected: AnyHashable? = nil

    let config: OnboardingPageConfig

    var body: some View {
        VStack {
            title
            list
            if config.selections.isEmpty {
                button
            } else {
                button
                    .disabled(selected == nil)
            }
        }
    }

    var title: some View {
        Text(config.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 50)
            .padding(.horizontal)
    }

    var list: some View {
        List {
            Group {
                ForEach(config.bulletPoints, id: \.self) { config in
                    OnboardingBulletPoint(config: config)
                }

                if !config.selections.isEmpty {
                    ForEach(config.selections, id: \.self) { selection in
                        if let musicService = selection as? MusicService {
                            SelectionCard(
                                config: selectionConfig(for: musicService),
                                isSelected: selected == selection,
                                action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        if selected == selection {
                                            selected = nil
                                            config.onSelection?(nil)
                                        } else {
                                            selected = musicService
                                            config.onSelection?(musicService)
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
    }

    var button: some View {
        Button {
            isLoading.toggle()

            config.onAction {
                isLoading.toggle()
            }
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    Text(config.buttonTitle)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .padding()
        .buttonStyle(.borderedProminent)
    }

    private func selectionConfig(for service: MusicService) -> SelectionCardConfig {
        switch service {
        case .appleMusic:
            SelectionCardConfig(
                imageName: "Apple Music",
                title: "Apple Music",
                description: "Use Apple Music to play songs. Requires an active Apple Music subscription."
            )
        case .spotify:
            SelectionCardConfig(
                imageName: "Spotify",
                title: "Spotify",
                description: "Use Spotify if you have an active subscription or want to use the free version."
            )
        }
    }
}

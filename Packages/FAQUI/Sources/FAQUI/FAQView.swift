//
//  FAQView.swift
//  FAQUI
//
//  Created by DG-SM-8669 on 31.12.2024.
//

import Foundation
import SharedUI
import SwiftUI

public struct FAQView: View {
    public init() {}

    public var body: some View {
        AppleInfoView(config: Self.appleInfoConfig())
    }
}

public extension FAQView {
    static func appleInfoConfig(
        buttonTitle: String? = nil,
        onAction: ((@escaping () -> Void) -> Void)? = nil
    ) -> AppleInfoConfig {
        AppleInfoConfig(
            title: "How to Play",
            bulletPoints: [
                .init(
                    icon: .system(name: "play.circle.fill"),
                    title: "Listen to the Preview",
                    description: """
                    Each round starts with a short preview of a song. Pay attention to the style and sound!
                    """
                ),
                .init(
                    icon: .system(name: "calendar"),
                    title: "Place on Timeline",
                    description: """
                    Place the song on the timeline between two reference tracks. The closer you get to the actual release year, the more points you earn.
                    """
                ),
                .init(
                    icon: .system(name: "music.mic"),
                    title: "Bonus Points",
                    description: """
                    Get extra points by correctly guessing the artist's name and song title.
                    """
                ),
                .init(
                    icon: .system(name: "checkmark.circle.fill"),
                    title: "Win the Game",
                    description: """
                    First player to correctly guess 10 songs wins! Incorrect guesses don't count towards your progress.
                    """
                ),
                .init(
                    icon: .system(name: "arrow.triangle.2.circlepath"),
                    title: "Taking Turns",
                    description: """
                    Players take turns guessing. If you guess incorrectly, the song is discarded and it's the next player's turn.
                    """
                ),
            ],
            buttonTitle: buttonTitle,
            onAction: onAction
        )
    }
}

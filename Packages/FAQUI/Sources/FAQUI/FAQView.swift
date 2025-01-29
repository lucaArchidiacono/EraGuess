//
//  FAQView.swift
//  FAQUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import AnalyticsDomain
import Foundation
import SharedUI
import SwiftUI

public struct FAQView: View {
    @Environment(\.dismiss) private var dismiss

    private let analyticsManager: AnalyticsManager

    public init(
        analyticsManager: AnalyticsManager
    ) {
        self.analyticsManager = analyticsManager
    }

    public var body: some View {
        content
            .toolbar {
                TextToolbar("Done", placement: .topBarTrailing) {
                    dismiss()
                }
            }
            .onAppear {
                analyticsManager.track(
                    event: .view(name: String(describing: FAQView.self))
                )
            }
    }

    private var content: some View {
        Self.appleInfoView()
    }
}

public extension FAQView {
    static func appleInfoView(
        buttonTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) -> some View {
        AppleInfoView(
            config: .init(
                title: "How to Play",
                buttonTitle: buttonTitle,
                onAction: onAction
            ),
            bulletPoints: {
                IconBulletPoint(
                    config: .init(
                        icon: .system(name: "play.circle.fill"),
                        title: "Listen to the Preview",
                        description: """
                        Each round starts with a short preview of a song. Pay attention to the style and sound!
                        """
                    )
                )
                IconBulletPoint(
                    config: .init(
                        icon: .system(name: "calendar"),
                        title: "Place on Timeline",
                        description: """
                        Place the song on the timeline between two reference tracks. The closer you get to the actual release year, the more points you earn.
                        """
                    )
                )
                //                IconBulletPoint(
                //                    config: .init(
                //                        icon: .system(name: "music.mic"),
                //                        title: "Bonus Points",
                //                        description: """
                //                        Get extra points by correctly guessing the artist's name and song title.
                //                        """
                //                    )
                //                )
                IconBulletPoint(
                    config: .init(
                        icon: .system(name: "checkmark.circle.fill"),
                        title: "Win the Game",
                        description: """
                        First player to correctly guess 10 songs wins! Incorrect guesses don't count towards your progress.
                        """
                    )
                )
                IconBulletPoint(
                    config: .init(
                        icon: .system(name: "arrow.triangle.2.circlepath"),
                        title: "Taking Turns",
                        description: """
                        Players take turns guessing. If you guess incorrectly, the song is discarded and it's the next player's turn.
                        """
                    )
                )
            }
        )
    }
}

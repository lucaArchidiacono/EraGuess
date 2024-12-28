//
//  NavigationButton.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import SwiftUI

public struct NavigationButton<TitleContent: View>: View {
    private let title: () -> TitleContent
    private let image: (() -> Image)?
    private let action: () -> Void

    // Specify concrete return type for string-based initialization
    public init<S: StringProtocol>(
        title: S,
        image: (() -> Image)? = nil,
        action: @escaping () -> Void
    ) where TitleContent == NavigationText<S> {
        self.title = { NavigationText(title) }
        self.image = image
        self.action = action
    }

    public init(
        @ViewBuilder title: @escaping (() -> TitleContent),
        image: (() -> Image)? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            NavigationLink(value: "") {
                if let image {
                    Label(
                        title: {
                            title()
                        },
                        icon: {
                            image()
                                .foregroundStyle(.gray)
                        }
                    )
                } else {
                    title()
                }
            }
            .contentShape(.interaction, Rectangle())
        }
        .buttonStyle(.plain)
    }
}

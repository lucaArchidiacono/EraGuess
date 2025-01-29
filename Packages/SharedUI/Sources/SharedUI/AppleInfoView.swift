//
//  AppleInfoView.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

public struct AppleInfoView<Content>: View where Content: View {
    @State private var isLoading: Bool = false

    private let config: AppleInfoConfig
    private let bulletPoints: [IconBulletPoint<Content>]

    public init(
        config: AppleInfoConfig,
        @IconBulletPointBuilder bulletPoints: () -> [IconBulletPoint<Content>]
    ) {
        self.config = config
        self.bulletPoints = bulletPoints()
    }

    public init(
        config: AppleInfoConfig
    ) where Content == Never {
        self.config = config
        bulletPoints = []
    }

    public var body: some View {
        VStack {
            title
            list

            if let buttonTitle = config.buttonTitle,
               let onAction = config.onAction
            {
                button(buttonTitle, action: onAction)
                    .padding(.bottom)
            }
        }
    }

    var title: some View {
        Text(config.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.horizontal)
    }

    var list: some View {
        List {
            ForEach(Array(bulletPoints.enumerated()), id: \.offset) { _, bulletPoint in
                bulletPoint
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
    }

    func button(
        _ title: String,
        action: @escaping () async -> Void
    ) -> some View {
        ProminentPushDownButton {
            isLoading = true

            Task {
                await action()
                isLoading = false
            }
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    Text(title)
                        .fontWeight(.bold)
                }
            }
        }
        .padding(.horizontal)
    }
}

public struct AppleInfoConfig {
    let title: String
    let buttonTitle: String?
    let onAction: (() async -> Void)?

    public init(
        title: String,
        buttonTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.onAction = {
            await withCheckedContinuation { continuation in
                onAction?()
                continuation.resume()
            }
        }
    }

    public init(
        title: String,
        buttonTitle: String? = nil,
        onAction: (() async -> Void)? = nil
    ) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.onAction = onAction
    }
}

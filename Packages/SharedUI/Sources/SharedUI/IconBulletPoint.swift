//
//  IconBulletPoint.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

public struct IconBulletPoint<Content: View>: View {
    // MARK: - Properties

    public let config: IconBulletPointConfig

    private var iconSize: CGFloat = 35
    private var iconSpacing: CGFloat = 16
    private var titleFont: Font = .headline
    private var descriptionFont: Font = .subheadline
    private var descriptionColor: Color = .secondary
    private var alignment: HorizontalAlignment = .leading
    private let content: Content?

    public init(
        config: IconBulletPointConfig,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.config = config
        self.content = content()
    }

    public init(
        config: IconBulletPointConfig
    ) where Content == Never {
        self.config = config
        content = nil
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: alignment) {
            HStack(alignment: .top) {
                bulletIcon
                    .padding(.trailing, iconSpacing)

                textContent
            }

            if let content {
                content
                    .padding(.top)
            }
        }
    }

    // MARK: - Private Views

    private var bulletIcon: some View {
        Group {
            if let icon = config.icon {
                switch icon {
                case let .system(name):
                    Image(systemName: name)
                        .resizable()
                case let .custom(name, bundle):
                    Image(name, bundle: bundle)
                        .resizable()
                }
            } else {
                Image(systemName: "circle.fill")
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.tint)
        .frame(
            width: config.icon == nil ? iconSize * 0.5 : iconSize,
            height: config.icon == nil ? iconSize * 0.5 : iconSize
        )
    }

    private var textContent: some View {
        VStack(alignment: alignment) {
            Text(config.title)
                .font(titleFont)

            if let description = config.description {
                Text(description)
                    .font(descriptionFont)
                    .foregroundColor(descriptionColor)
            }
        }
    }
}

// MARK: - View Modifiers

public extension IconBulletPoint {
    func iconSize(_ size: CGFloat) -> IconBulletPoint {
        var view = self
        view.iconSize = size
        return view
    }

    func iconSpacing(_ spacing: CGFloat) -> IconBulletPoint {
        var view = self
        view.iconSpacing = spacing
        return view
    }

    func titleFont(_ font: Font) -> IconBulletPoint {
        var view = self
        view.titleFont = font
        return view
    }

    func descriptionFont(_ font: Font) -> IconBulletPoint {
        var view = self
        view.descriptionFont = font
        return view
    }

    func descriptionColor(_ color: Color) -> IconBulletPoint {
        var view = self
        view.descriptionColor = color
        return view
    }

    func contentAlignment(_ alignment: HorizontalAlignment) -> IconBulletPoint {
        var view = self
        view.alignment = alignment
        return view
    }
}

public struct IconBulletPointConfig: Hashable {
    let icon: BulletPointIcon?
    let title: String
    let description: String?

    public enum BulletPointIcon: Hashable {
        case system(name: String)
        case custom(name: String, bundle: Bundle? = .main)
    }

    public init(
        icon: BulletPointIcon? = nil,
        title: String,
        description: String?
    ) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}

@resultBuilder
public struct IconBulletPointBuilder {
    public static func buildBlock<V>(_ components: IconBulletPoint<V>...) -> [IconBulletPoint<V>] {
        components
    }

    public static func buildOptional<V>(_ component: IconBulletPoint<V>?) -> [IconBulletPoint<V>] {
        component.map { [$0] } ?? []
    }

    public static func buildEither<V>(first component: IconBulletPoint<V>) -> [IconBulletPoint<V>] {
        [component]
    }

    public static func buildEither<V>(second component: IconBulletPoint<V>) -> [IconBulletPoint<V>] {
        [component]
    }

    public static func buildArray<V>(_ components: [IconBulletPoint<V>]) -> [IconBulletPoint<V>] {
        components
    }
}

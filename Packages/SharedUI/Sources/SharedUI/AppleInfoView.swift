//
//  AppleInfoView.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

public struct AppleInfoConfig {
    let title: String
    let bulletPoints: [BulletPointConfig]
    let buttonTitle: String?
    let onAction: ((@escaping () -> Void) -> Void)?

    public init(
        title: String,
        bulletPoints: [BulletPointConfig],
        buttonTitle: String? = nil,
        onAction: ((@escaping () -> Void) -> Void)? = nil
    ) {
        self.title = title
        self.bulletPoints = bulletPoints
        self.buttonTitle = buttonTitle
        self.onAction = onAction
    }
}

public struct AppleInfoView: View {
    @State private var isLoading: Bool = false

    private let config: AppleInfoConfig

    public init(
        config: AppleInfoConfig
    ) {
        self.config = config
    }

    public var body: some View {
        VStack {
            title
            list

            if let buttonTitle = config.buttonTitle,
               let onAction = config.onAction
            {
                button(buttonTitle, action: onAction)
            }
        }
    }

    var title: some View {
        Text(config.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 30)
            .padding(.horizontal)
    }

    var list: some View {
        List {
            Group {
                bulletPoints
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
    }

    func button(_ title: String, action: @escaping (@escaping () -> Void) -> Void) -> some View {
        Button {
            isLoading.toggle()

            action {
                isLoading.toggle()
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
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .padding()
        .buttonStyle(.borderedProminent)
    }

    private var bulletPoints: some View {
        ForEach(config.bulletPoints, id: \.self) { config in
            IconBulletPoint(config: config)
        }
    }
}

//
//  CloseButton.swift
//
//
//  Created by Luca Archidiacono on 01.05.2024.
//

import Foundation
import SwiftUI
import UIKit

public struct CloseButton: View {
    @Environment(\.colorScheme) private var colorScheme

    private let action: (() -> Void)?

    public init(
        action: (() -> Void)? = nil
    ) {
        self.action = action
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .font(Font.body.weight(.bold))
                .scaleEffect(0.416)
                .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
        }
        .contentShape(.interaction, Circle())
        .onTapGesture { action?() }
    }
}

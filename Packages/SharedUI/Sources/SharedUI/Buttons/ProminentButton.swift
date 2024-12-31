//
//  ProminentButton.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

public struct ProminentButton<Content: View>: View {
    private let action: () -> Void
    private let label: () -> Content

    public init(
        action: @escaping () -> Void,
        label: @escaping () -> Content
    ) {
        self.label = label
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            label()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .padding(.horizontal)
        .buttonStyle(.borderedProminent)
    }
}

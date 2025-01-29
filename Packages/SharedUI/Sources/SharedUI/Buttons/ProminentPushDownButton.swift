//
//  ProminentPushDownButton.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 15.01.2025.
//

import Foundation
import Pow
import SwiftUI

public struct ProminentPushDownButton<Content: View>: View {
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
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.tint, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PushDownButtonStyle())
    }
}

#Preview {
    ProminentPushDownButton(action: {}, label: { Text("Button") })
}

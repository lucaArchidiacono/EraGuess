//
//  SettingsButton.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import SwiftUI

public struct SettingsButton: View {
    private let onTap: () -> Void

    public init(
        onTap: @escaping () -> Void
    ) {
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "gear")
        }
    }
}

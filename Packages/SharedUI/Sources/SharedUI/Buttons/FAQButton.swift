//
//  FAQButton.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import SwiftUI

public struct FAQButton: View {
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
            Image(systemName: "questionmark.circle")
        }
    }
}

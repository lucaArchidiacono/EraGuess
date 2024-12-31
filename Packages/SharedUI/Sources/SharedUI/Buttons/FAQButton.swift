//
//  FAQButton.swift
//  SharedUI
//
//  Created by DG-SM-8669 on 31.12.2024.
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

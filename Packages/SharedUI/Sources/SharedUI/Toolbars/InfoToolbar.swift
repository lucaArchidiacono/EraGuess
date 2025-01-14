//
//  InfoToolbar.swift
//
//
//  Created by Luca Archidiacono on 29.04.2024.
//

import Foundation
import SwiftUI

public struct InfoToolbar: ToolbarContent {
    private let placement: ToolbarItemPlacement
    private let onTap: () -> Void

    public init(
        placement: ToolbarItemPlacement = .automatic,
        onTap: @escaping () -> Void
    ) {
        self.placement = placement
        self.onTap = onTap
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button {
                onTap()
            } label: {
                Image(systemName: "info.circle")
            }
        }
    }
}

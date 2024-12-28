//
//  AddToolbar.swift
//
//
//  Created by Luca Archidiacono on 21.02.2024.
//

import Foundation
import SwiftUI

public struct AddToolbar: ToolbarContent {
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
                Image(systemName: "plus")
            }
        }
    }
}

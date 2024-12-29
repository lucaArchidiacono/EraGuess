//
//  SettingsToolbar.swift
//
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import Foundation
import SwiftUI

public struct SettingsToolbar: ToolbarContent {
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
            SettingsButton(onTap: onTap)
        }
    }
}

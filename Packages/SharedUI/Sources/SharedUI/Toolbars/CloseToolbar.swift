//
//  CloseToolbar.swift
//  Loadle
//
//  Created by Luca Archidiacono on 28.04.2024.
//

import Foundation
import SwiftUI
import UIKit

public struct CloseToolbar: ToolbarContent {
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
            CloseButton {
                onTap()
            }
        }
    }
}

//
//  FAQToolbar.swift
//  SharedUI
//
//  Created by DG-SM-8669 on 31.12.2024.
//

import Foundation
import SwiftUI

public struct FAQToolbar: ToolbarContent {
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
            FAQButton(onTap: onTap)
        }
    }
}

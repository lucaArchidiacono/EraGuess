//
//  TextToolbar.swift
//
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import Foundation
import SwiftUI

public struct TextToolbar: ToolbarContent {
    private let button: Button<Text>
    private let placement: ToolbarItemPlacement

    public init(
        _ text: some StringProtocol,
        placement: ToolbarItemPlacement = .automatic,
        onTap: @escaping () -> Void
    ) {
        button = Button(text, action: onTap)
        self.placement = placement
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            button
        }
    }
}

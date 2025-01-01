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
    private var width: CGFloat = 22
    private var height: CGFloat = 22
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
            .frame(width: width, height: height)
        }
    }
}

public extension CloseToolbar {
    func width(_ width: CGFloat) -> Self {
        var copy = self
        copy.width = width
        return copy
    }
    func height(_ height: CGFloat) -> Self {
        var copy = self
        copy.height = height
        return copy
    }
    func frame(width: CGFloat, height: CGFloat) -> Self {
        var copy = self
        copy.width = width
        copy.height = height
        return copy
    }
}

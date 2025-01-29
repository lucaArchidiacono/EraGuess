//
//  PushDownButtonStyle.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 15.01.2025.
//

import Pow
import SwiftUI

struct PushDownButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.75 : 1)
            .conditionalEffect(
                .pushDown,
                condition: configuration.isPressed
            )
    }
}

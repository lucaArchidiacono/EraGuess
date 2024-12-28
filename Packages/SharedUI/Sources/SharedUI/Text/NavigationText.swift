//
//  NavigationText.swift
//  SharedUI
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import SwiftUI

public struct NavigationText<S>: View where S: StringProtocol {
    private let text: S

    public init(_ text: S) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .fontWeight(.bold)
    }
}

//
//  NavigationLink+.swift
//  Fundamentals
//
//  Created by Luca Archidiacono on 16.09.2024.
//

import Foundation
import SwiftUI

public extension NavigationLink where Label == EmptyView, Destination == EmptyView {
    static var empty: NavigationLink {
        self.init(destination: EmptyView(), label: { EmptyView() })
    }
}

public extension NavigationLink where Destination == EmptyView {
    static func empty(label: () -> Label) -> NavigationLink {
        self.init(destination: EmptyView(), label: label)
    }
}

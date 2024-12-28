//
//  Router.swift
//
//
//  Created by Luca Archidiacono on 13.09.2024.
//

import Foundation

@MainActor
@Observable
public final class Router<D: Hashable, P: Hashable & Identifiable> {
    public var path: [D] = []
    public var sheet: P?
    public var fullScreen: P?

    public var isPresenting: Bool {
        sheet != nil || fullScreen != nil
    }

    public var isRoot: Bool {
        path.isEmpty && !isPresenting
    }

    public init() {}

    public func pop() {
        guard path.count > 0 else { return }
        path.removeLast(1)
    }

    public func pop(last count: Int) {
        guard path.count > 0 else { return }
        let rest = path.count - max(path.count - count, 0)
        path.removeLast(rest)
    }
}

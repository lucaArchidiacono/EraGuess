//
//  Navigation.swift
//  HomeUI
//
//  Created by DG-SM-8669 on 28.12.2024.
//

import Foundation
import Models

public enum Destination: Hashable, Identifiable {
    case unknown

    public var id: Self { self }
}

public enum Page: Hashable, Identifiable {
    case settings
    case subscription
    case game

    public var id: Self { self }
}

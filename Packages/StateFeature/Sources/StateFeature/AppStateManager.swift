//
//  AppStateManager.swift
//  StateFeature
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import Foundation
import Sharing
import SwiftUI

@Observable
public final class AppStateManager {
    @ObservationIgnored
    @Shared(.appStorage("hasSeenOnboarding")) public var hasSeenOnboarding: Bool = false

    public init() {}
}

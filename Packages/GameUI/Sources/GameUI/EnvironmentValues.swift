//
//  EnvironmentValues.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import SwiftUI
import HapticFeedbackFeature

@MainActor
private struct HapticFeedbackManagerKey: @preconcurrency EnvironmentKey {
    static let defaultValue: HapticFeedbackManager = .init()
}

extension EnvironmentValues {
    var hapticFeedbackManager: HapticFeedbackManager {
        get { self[HapticFeedbackManagerKey.self] }
        set { self[HapticFeedbackManagerKey.self] = newValue }
    }
}

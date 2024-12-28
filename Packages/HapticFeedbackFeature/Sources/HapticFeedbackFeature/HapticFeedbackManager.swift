//
//  HapticFeedbackManager.swift
//  CasaZurigo
//
//  Created by Luca Archidiacono on 17.09.23.
//

import CoreHaptics
import UIKit

@MainActor
public class HapticFeedbackManager {
    public enum HapticType {
        case buttonPress
        case dataRefresh(intensity: CGFloat)
        case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
        case tabSelection
    }

    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()

    public init() {
        prepare()
    }

    private func prepare() {
        selectionGenerator.prepare()
        impactGenerator.prepare()
        notificationGenerator.prepare()
    }

    public func fireHaptic(of type: HapticType) {
        guard supportsHaptics else { return }

        switch type {
        case .buttonPress:
            impactGenerator.impactOccurred()
            prepare()
        case .dataRefresh:
            break
        case let .notification(type):
            notificationGenerator.notificationOccurred(type)
            prepare()
        case .tabSelection:
            selectionGenerator.selectionChanged()
            prepare()
        }
    }

    public var supportsHaptics: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
}

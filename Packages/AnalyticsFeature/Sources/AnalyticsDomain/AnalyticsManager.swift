//
//  AnalyticsManager.swift
//  AnalyticsFeature
//
//  Created by Luca Archidiacono on 16.10.2024.
//

public protocol AnalyticsManager: Sendable {
    func track(event: Event)
}

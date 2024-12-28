//
//  AnalyticsConfiguration.swift
//  AnalyticsFeature
//
//  Created by Luca Archidiacono on 16.10.2024.
//

import Foundation

public protocol AnalyticsConfiguration {
    var apiKey: String { get }
    var securityGroupIdentifier: String { get }
}

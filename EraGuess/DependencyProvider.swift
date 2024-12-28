//
//  DependencyProvider.swift
//  EraGuess
//
//  Created by DG-SM-8669 on 28.12.2024.
//

import AnalyticsDomain
import Permission

@MainActor
protocol DependencyProvider {
    // MARK: - Permissions

    var locationPermissionProvider: LocationPermissionProvider { get }
    var notificationPermissionProvider: NotificationPermissionProvider { get }
}

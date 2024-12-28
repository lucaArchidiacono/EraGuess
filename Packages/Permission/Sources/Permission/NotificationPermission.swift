//
//  NotificationPermission.swift
//  Permission
//
//  Created by Luca Archidiacono on 15.11.2024.
//

import Foundation
import Logger
import UIKit
import UserNotifications

public final class NotificationPermissionProvider: PermissionProvider, Sendable {
    private let logger = Logger(label: "NotificationPermissionProvider")

    private var requestTask: Task<Permission.Status, Never>?

    public init() {}

    public nonisolated
    func fetchStatus() async -> Permission.Status {
        let settings = await UNUserNotificationCenter.current().notificationSettings()

        switch settings.authorizationStatus {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .provisional:
            return .authorized
        case .ephemeral:
            return .authorized
        @unknown default:
            logger.warning("Case \(settings.authorizationStatus) not handeled!")
            return .denied
        }
    }

    @discardableResult
    public func requestPermission() async -> Permission.Status {
        if let requestTask {
            let result = await requestTask.value
            self.requestTask = nil
            return result
        }

        let requestTask = Task<Permission.Status, Never> {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])

                UIApplication.shared.registerForRemoteNotifications()
            } catch {
                logger.error("Failed to request authorization for Notification with error: \(error)")
            }

            return await fetchStatus()
        }

        self.requestTask = requestTask

        let result = await requestTask.value

        self.requestTask = nil

        return result
    }
}

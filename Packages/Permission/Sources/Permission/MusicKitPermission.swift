//
//  MusicKitPermission.swift
//  Permission
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Logger
import MusicKit

public final class MusicKitPermissionProvider: PermissionProvider, Sendable {
    private let logger = Logger(label: String(describing: MusicKitPermissionProvider.self))

    private var requestTask: Task<Permission.Status, Never>?

    public init() {}

    public nonisolated
    func fetchStatus() async -> Permission.Status {
        let status = MusicAuthorization.currentStatus

        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .denied
        @unknown default:
            logger.warning("Case \(status) not handeled!")
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
            _ = await MusicAuthorization.request()
            return await fetchStatus()
        }

        self.requestTask = requestTask

        let result = await requestTask.value

        self.requestTask = nil

        return result
    }
}

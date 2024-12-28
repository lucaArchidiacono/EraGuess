//
//  LocationPermission.swift
//  Permission
//
//  Created by Luca Archidiacono on 15.11.2024.
//

import Foundation
import Logger
import MapKit

public final class LocationPermissionProvider: NSObject, PermissionProvider, CLLocationManagerDelegate {
    private let logger = Logger(label: String(describing: LocationPermissionProvider.self))

    private var requestTask: Task<Permission.Status, Never>?
    private var requestContinuation: CheckedContinuation<Void, Never>?
    private let manager = CLLocationManager()

    override public init() {
        super.init()

        manager.delegate = self
    }

    @discardableResult
    public func requestPermission() async -> Permission.Status {
        if let requestTask {
            let result = await requestTask.value
            self.requestTask = nil
            return result
        }

        let requestTask = Task<Permission.Status, Never> { [weak self] in
            guard let self else { return .notDetermined }

            if manager.authorizationStatus == .notDetermined {
                logger.info("Requesting Location Access.")
                await withCheckedContinuation { continuation in
                    requestContinuation = continuation
                    manager.requestWhenInUseAuthorization()
                }
            }
            return await fetchStatus()
        }

        self.requestTask = requestTask

        let result = await requestTask.value

        return result
    }

    public func fetchStatus() async -> Permission.Status {
        logger.info("Fetch Location Access status.")
        let status: Permission.Status? = switch manager.authorizationStatus {
        case .notDetermined:
            .notDetermined
        case .restricted:
            .denied
        case .denied:
            .denied
        case .authorizedAlways:
            .authorized
        case .authorizedWhenInUse:
            .authorized
        case .authorized:
            .authorized
        @unknown default:
            nil
        }

        guard let status else {
            logger.warning("Location Access status CASE \(manager.authorizationStatus) not handeled!")
            fatalError()
        }

        logger.info("Location Access status: \(status)")

        return status
    }

    public nonisolated
    func locationManagerDidChangeAuthorization(_: CLLocationManager) {
        Task {
            await requestContinuation?.resume()
        }
    }
}

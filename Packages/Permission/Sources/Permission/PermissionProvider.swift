//
//  PermissionProvider.swift
//  Permission
//
//  Created by Luca Archidiacono on 15.11.2024.
//

@MainActor
public protocol PermissionProvider {
    func fetchStatus() async -> Permission.Status

    @discardableResult
    func requestPermission() async -> Permission.Status
}

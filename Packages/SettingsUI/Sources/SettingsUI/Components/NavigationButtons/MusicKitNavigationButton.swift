//
//  MusicKitNavigationButton.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 24.12.2024.
//

import EraGuessShared
import Permission
import SharedUI
import SwiftUI

struct MusicKitNavigationButton: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    @State private var permissionStatus: Permission.Status = .notDetermined

    public let musicKitPermissionProvider: MusicKitPermissionProvider

    var body: some View {
        navigationButton
            .buttonStyle(.plain)
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    fetchPermissionStatus()
                }
            }
            .onAppear {
                fetchPermissionStatus()
            }
    }

    private func fetchPermissionStatus() {
        Task {
            permissionStatus = await musicKitPermissionProvider.fetchStatus()
        }
    }

    private var navigationButton: some View {
        Button {
            openURL(EraGuessShared.appSettingsURL)
        } label: {
            HStack {
                NavigationText("MusicKit")

                Spacer()

                HStack {
                    switch permissionStatus {
                    case .authorized:
                        Circle()
                            .fill(Color.green)
                            .frame(height: 10)
                        Text("Enabled")
                            .foregroundStyle(.secondary)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.gray)
                    case .denied:
                        Circle()
                            .fill(Color.red)
                            .frame(height: 10)
                        Text("Disabled")
                            .foregroundStyle(.secondary)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.gray)
                    case .notDetermined:
                        Circle()
                            .fill(Color.gray)
                            .frame(height: 10)
                        Text("Unknown")
                            .foregroundStyle(.secondary)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .frame(alignment: .trailing)
        }
    }
}

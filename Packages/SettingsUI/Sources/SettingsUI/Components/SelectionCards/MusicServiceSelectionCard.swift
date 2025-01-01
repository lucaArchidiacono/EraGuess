//
//  MusicServiceSelectionCard.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 01.01.2025.
//

import SwiftUI
import EraGuessUI
import Models
import StateFeature
import Permission

struct MusicServiceSelectionCard: View {
    @Environment(UserPreferencesManager.self) private var userPreferencesManager
    @Environment(\.musicKitPermissionProvider) private var musicKitPermissionProvider
    @Environment(\.analyticsManager) private var analyticsManager
    
    @State private var musicKitPermissionState: Permission.Status = .notDetermined

    let musicService: MusicService
    
    var body: some View {
        content
            .task {
                musicKitPermissionState = await musicKitPermissionProvider.fetchStatus()

                if musicKitPermissionState != .authorized {
                    userPreferencesManager.$musicServices.withLock { _ = $0.remove(.appleMusic) }
                }
            }
    }
    
    var content: some View {
        switch musicService {
        case .appleMusic:
            SelectionCard(
                config: .init(
                    header: .image(Image("Apple Music", bundle: .module)),
                    title: "Apple Music",
                    description: """
                    No subscription required.
                    Its the preferred service with better quality and better music matching.
                    """
                ),
                isSelected: musicKitPermissionState == .authorized && userPreferencesManager.musicServices.contains(musicService),
                action: {
                    Task {
                        if musicKitPermissionState == .notDetermined {
                            let status = await musicKitPermissionProvider.requestPermission()
                            analyticsManager.track(event: .request(.permission(.musicKit, status: status)))
                            musicKitPermissionState = status
                        }

                        if musicKitPermissionState == .authorized {
                            if userPreferencesManager.musicServices.contains(musicService) {
                                userPreferencesManager.$musicServices.withLock { _ = $0.remove(musicService) }
                            } else {
                                userPreferencesManager.$musicServices.withLock { _ = $0.insert(musicService) }
                            }
                        }
                    }
                }
            )
            .disabled(
                musicKitPermissionState == .denied ||
                    userPreferencesManager.musicServices.contains(musicService) &&
                    userPreferencesManager.musicServices.count == 1
            )
        case .spotify:
            SelectionCard(
                config: .init(
                    header: .image(Image("Spotify", bundle: .module)),
                    title: "Spotify",
                    description: """
                    No subscription required.
                    It's a good alternative and is used as fallback when Apple Music is selected.
                    """
                ),
                isSelected: userPreferencesManager.musicServices.contains(musicService),
                action: {
                    if userPreferencesManager.musicServices.contains(musicService) {
                        userPreferencesManager.$musicServices.withLock { _ = $0.remove(musicService) }
                    } else {
                        userPreferencesManager.$musicServices.withLock { _ = $0.insert(musicService) }
                    }
                }
            )
            .disabled(
                musicKitPermissionState != .authorized ||
                    userPreferencesManager.musicServices.contains(musicService) &&
                    userPreferencesManager.musicServices.count == 1
            )
        }
    }
}

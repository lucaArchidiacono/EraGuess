//
//  StreamingServiceSection.swift
//  SettingsUI
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import Foundation
import Permission
import SwiftUI
import EraGuessUI
import StateFeature
import Models

struct StreamingServiceSection: View {
    @Environment(UserPreferencesManager.self) private var userPreferencesManager
    
    @State private var musicKitPermissionState: Permission.Status = .notDetermined
    
    let musicKitPermissionProvider: MusicKitPermissionProvider

    var body: some View {
        section
            .listRowBackground(Color.clear)
            .task {
                musicKitPermissionState = await musicKitPermissionProvider.fetchStatus()
                
                if musicKitPermissionState != .authorized {
                    userPreferencesManager.$musicServices.withLock { _ = $0.remove(.appleMusic) }
                }
            }
    }
    
    private var section: some View {
        Section {
            content
                .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
        } header: {
            Text("Streaming Services")
        } footer: {
            Text("""
                Keep in mind if you do give permission to use Apple Music, Spotify will be used and can not be disabled.
                If you allow Apple Music, it will be used as the primary service and you are able to disable Spotify.
                """)
        }
    }
    
    private var content: some View {
        ForEach(MusicService.allCases, id: \.self) { musicService in
            selectionCard(musicService)
                .listRowSeparator(.hidden)
        }
    }

    @ViewBuilder
    private func selectionCard(_ service: MusicService) -> some View {
        switch service {
        case .appleMusic:
            SelectionCard(
                config: .init(
                    header: .image(Image("Apple Music", bundle: .module)),
                    title: "Apple Music",
                    description: """
                    No subscription required.
                    Use Apple Music to play the music as preview.
                    Its the preferred service with better quality and better music matching.
                    """
                ),
                isSelected: musicKitPermissionState == .authorized && userPreferencesManager.musicServices.contains(service),
                action: {
                    Task {
                        if musicKitPermissionState == .notDetermined {
                            musicKitPermissionState = await musicKitPermissionProvider.requestPermission()
                        }
                        
                        if musicKitPermissionState == .authorized {
                            if userPreferencesManager.musicServices.contains(service) {
                                userPreferencesManager.$musicServices.withLock { _ = $0.remove(service) }
                            } else {
                                userPreferencesManager.$musicServices.withLock { _ = $0.insert(service) }
                            }
                        }
                    }
                }
            )
            .disabled(
                musicKitPermissionState == .denied ||
                userPreferencesManager.musicServices.contains(service) &&
                userPreferencesManager.musicServices.count == 1
            )
        case .spotify:
            SelectionCard(
                config: .init(
                    header: .image(Image("Spotify", bundle: .module)),
                    title: "Spotify",
                    description: """
                    No subscription required.
                    Use Spotify to play the music as preview.
                    It's a good alternative and is used as fallback when Apple Music is selected.
                    """
                ),
                isSelected: userPreferencesManager.musicServices.contains(service),
                action: {
                    if userPreferencesManager.musicServices.contains(service) {
                        userPreferencesManager.$musicServices.withLock { _ = $0.remove(service) }
                    } else {
                        userPreferencesManager.$musicServices.withLock { _ = $0.insert(service) }
                    }
                }
            )
            .disabled(
                musicKitPermissionState != .authorized ||
                userPreferencesManager.musicServices.contains(service) &&
                userPreferencesManager.musicServices.count == 1
            )
        }
    }
}

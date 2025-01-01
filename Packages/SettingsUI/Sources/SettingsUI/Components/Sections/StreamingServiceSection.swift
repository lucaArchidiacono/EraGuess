//
//  StreamingServiceSection.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import Foundation
import Models
import SwiftUI

struct StreamingServiceSection: View {
    var body: some View {
        section
            .listRowBackground(Color.clear)
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
            MusicServiceSelectionCard(musicService: musicService)
                .listRowSeparator(.hidden)
        }
    }
}

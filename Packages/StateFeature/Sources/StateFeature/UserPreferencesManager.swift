//
//  UserPreferencesManager.swift
//
//
//  Created by Luca Archidiacono on 09.05.2024.
//

import Foundation
import Models
import Sharing
import SwiftUI

@Observable
public final class UserPreferencesManager {
    private static let musicServicesURL = URL.applicationDirectory.appending(path: "musicServices.json")
    
    @ObservationIgnored
    @Shared(.fileStorage(musicServicesURL)) public var musicServices: Set<MusicService> = [.spotify]

    public init() {}
}

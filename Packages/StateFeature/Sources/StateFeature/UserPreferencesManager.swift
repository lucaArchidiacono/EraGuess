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
    @ObservationIgnored
    @Shared(.appStorage("preferredMusicService")) public var preferredMusicService: MusicService? = nil

    public init() {}
}

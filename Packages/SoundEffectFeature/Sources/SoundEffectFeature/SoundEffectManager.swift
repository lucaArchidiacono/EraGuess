//
//  SoundEffectManager.swift
//  SoundEffectFeature
//
//  Created by Luca Archidiacono on 17.09.23.
//

import AudioToolbox
import AVKit
import CoreHaptics

@MainActor
public class SoundEffectManager {
    public enum SoundEffect: String, CaseIterable {
        case pull, refresh, tabSelection, bookmark, favorite, share
    }

    private var pullId: SystemSoundID = 0
    private var refreshId: SystemSoundID = 1
    private var tabSelectionId: SystemSoundID = 2
    private var bookmarkId: SystemSoundID = 3
    private var favoriteId: SystemSoundID = 4
    private var shareId: SystemSoundID = 5

    public init() {
        registerSounds()
    }

    private func registerSounds() {
        for effect in SoundEffect.allCases {
            if let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "wav") {
                switch effect {
                case .pull:
                    AudioServicesCreateSystemSoundID(url as CFURL, &pullId)
                case .refresh:
                    AudioServicesCreateSystemSoundID(url as CFURL, &refreshId)
                case .tabSelection:
                    AudioServicesCreateSystemSoundID(url as CFURL, &tabSelectionId)
                case .bookmark:
                    AudioServicesCreateSystemSoundID(url as CFURL, &bookmarkId)
                case .favorite:
                    AudioServicesCreateSystemSoundID(url as CFURL, &favoriteId)
                case .share:
                    AudioServicesCreateSystemSoundID(url as CFURL, &shareId)
                }
            }
        }
    }

    public func playSound(of type: SoundEffect) {
        switch type {
        case .pull:
            AudioServicesPlaySystemSound(pullId)
        case .refresh:
            AudioServicesPlaySystemSound(refreshId)
        case .tabSelection:
            AudioServicesPlaySystemSound(tabSelectionId)
        case .bookmark:
            AudioServicesPlaySystemSound(bookmarkId)
        case .favorite:
            AudioServicesPlaySystemSound(favoriteId)
        case .share:
            AudioServicesPlaySystemSound(shareId)
        }
    }
}

//
//  PlayerService.swift
//  Services
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import AVFoundation
import Logger
import Models

public actor PlayerService {
    private let logger = Logger(label: String(describing: PlayerService.self))
    private let player = AVPlayer()

    private var playbackState: PlaybackState = .stopped

    public init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            logger.error("Failed to set audio session category: \(error)")
        }
    }

    func play(url: URL) {
        logger.debug("Playing audio from url: \(url)")
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        playbackState = .playing
    }

    func pause() {
        guard playbackState == .playing else { return }
        logger.debug("Pausing audio")
        player.pause()
        playbackState = .paused
    }

    func stop() {
        guard playbackState == .playing else { return }
        logger.debug("Stopping audio")
        player.pause()
        player.replaceCurrentItem(with: nil)
        playbackState = .stopped
    }
    
    func resume() {
        guard playbackState == .paused else { return }
        logger.debug("Resuming audio")
        player.play()
        playbackState = .playing
    }

    func getPlaybackState() -> PlaybackState {
        playbackState
    }
}

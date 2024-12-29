//
//  PlayerService.swift
//  Services
//
//  Created by DG-SM-8669 on 29.12.2024.
//

import AVFoundation
import Logger

public actor PlayerService {
    private let logger = Logger(label: String(describing: PlayerService.self))
    private let player = AVPlayer()

    private var isPlaying = false

    public init() {}

    func play(url: URL) {
        logger.debug("Playing audio from url: \(url)")
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        isPlaying = true
    }

    func pause() {
        guard isPlaying else { return }
        logger.debug("Pausing audio")
        player.pause()
        isPlaying = false
    }

    func stop() {
        guard isPlaying else { return }
        logger.debug("Stopping audio")
        player.pause()
        player.replaceCurrentItem(with: nil)
        isPlaying = false
    }

    func getIsPlaying() -> Bool {
        isPlaying
    }
}

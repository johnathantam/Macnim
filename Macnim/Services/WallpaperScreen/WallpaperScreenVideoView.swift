//
//  VideoView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//

import AppKit
import SwiftUI
import AVFoundation

final class WallpaperScreenVideoView: NSView {
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        wantsLayer = true
        layer = CALayer()
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func play(videoURL: URL) {
        // Remove any existing video
        playerLayer?.removeFromSuperlayer()

        let item = AVPlayerItem(url: videoURL)
        let player = AVQueuePlayer()
        let looper = AVPlayerLooper(
            player: player,
            templateItem: item
        )

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.frame = bounds

        self.layer?.addSublayer(layer)

        self.queuePlayer = player
        self.playerLooper = looper
        self.playerLayer = layer

        player.isMuted = true
        player.play()
    }

    func clear() {
        queuePlayer?.pause()
        playerLayer?.removeFromSuperlayer()

        queuePlayer = nil
        playerLooper = nil
        playerLayer = nil
    }
    
    override func layout() {
        super.layout()
        playerLayer?.frame = bounds
    }
}

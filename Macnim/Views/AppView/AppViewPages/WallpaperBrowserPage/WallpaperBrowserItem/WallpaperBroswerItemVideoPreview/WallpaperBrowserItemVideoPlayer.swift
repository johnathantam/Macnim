//
//  WallpaperBrowserItemVideoPreviewView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-15.
//

import AppKit
import AVFoundation

final class WallpaperBrowserItemVideoPlayer: NSView {

    private let player: AVQueuePlayer
    private let playerLooper: AVPlayerLooper
    private let playerLayer: AVPlayerLayer

    init(videoURL: URL) {
        let playerItem = AVPlayerItem(url: videoURL)
        
        self.player = AVQueuePlayer()
        self.playerLooper = AVPlayerLooper( player: player, templateItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: player)

        super.init(frame: .zero)

        wantsLayer = true

        playerLayer.videoGravity = .resizeAspectFill

        layer?.addSublayer(playerLayer)

        player.isMuted = true
        
        player.play()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()

        playerLayer.frame = bounds
    }
}

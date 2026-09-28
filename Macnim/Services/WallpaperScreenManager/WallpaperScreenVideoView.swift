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
    
    private var fitStyle: WallpaperDisplayFitStyle = .fill
    private var volume: WallpaperDisplayVolume = WallpaperDisplayVolume(0)
    private var playbackSpeed: WallpaperDisplayPlaybackSpeed = .normal
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        wantsLayer = true
        layer = CALayer()
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    public func getFitStyle() -> WallpaperDisplayFitStyle {
        return fitStyle
    }
    
    public func setFitStyle(newFitStyle: WallpaperDisplayFitStyle) -> Void {
        fitStyle = newFitStyle
        playerLayer?.videoGravity = newFitStyle.videoGravity
    }
    
    public func getVolume() -> WallpaperDisplayVolume {
        return volume
    }
    
    public func setVolume(newVolume: WallpaperDisplayVolume) -> Void {
        volume = newVolume
        queuePlayer?.volume = newVolume.value
    }
    
    public func getPlaybackSpeed() -> WallpaperDisplayPlaybackSpeed {
        return playbackSpeed
    }
    
    public func setPlaybackSpeed(newPlaybackSpeed: WallpaperDisplayPlaybackSpeed) -> Void {
        playbackSpeed = newPlaybackSpeed
        queuePlayer?.rate = newPlaybackSpeed.rawValue
    }
    
    public func isPlaying() -> Bool {
        return queuePlayer != nil
    }
    
    public func play(videoURL: URL) {
        // Remove any existing video
        playerLayer?.removeFromSuperlayer()

        let item = AVPlayerItem(url: videoURL)
        
        let player = AVQueuePlayer()
        player.volume = volume.value
        player.rate = playbackSpeed.rawValue
        
        let looper = AVPlayerLooper(
            player: player,
            templateItem: item
        )

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = fitStyle.videoGravity
        layer.frame = bounds

        self.layer?.addSublayer(layer)

        self.queuePlayer = player
        self.playerLooper = looper
        self.playerLayer = layer

        player.play()
    }
    
    public func pause() {
        queuePlayer?.pause()
    }

    public func clear() {
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

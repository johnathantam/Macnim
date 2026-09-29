//
//  LoopingVideoPlayer.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-28.
//

import SwiftUI
import AVKit

private struct PlayerNSView: NSViewRepresentable {
    let player: AVPlayer
    let playbackSpeed: WallpaperDisplayPlaybackSpeed
    let volume: WallpaperDisplayVolume
    var controlsStyle: AVPlayerViewControlsStyle = .default
    var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    
    init(
        player: AVPlayer,
        playbackSpeed: WallpaperDisplayPlaybackSpeed,
        volume: WallpaperDisplayVolume,
        controlsStyle: AVPlayerViewControlsStyle,
        videoGravity: AVLayerVideoGravity
    ) {
        self.player = player
        self.playbackSpeed = playbackSpeed
        self.volume = volume
        self.controlsStyle = controlsStyle
        self.videoGravity = videoGravity
    }

    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.player = player
        view.player?.rate = playbackSpeed.rawValue
        view.player?.volume = volume.value
        view.controlsStyle = controlsStyle
        view.videoGravity = videoGravity
        return view
    }

    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        if nsView.player !== player {
            nsView.player = player
        }
    }
}

struct LoopingVideoPlayer: View {
    private let videoURL: URL
    private var playbackSpeed: WallpaperDisplayPlaybackSpeed
    private var volume: WallpaperDisplayVolume
    private var controlsStyle: AVPlayerViewControlsStyle
    private var videoGravity: AVLayerVideoGravity

    @State private var player: AVPlayer?
    @State private var loopObserver: NSObjectProtocol?
    
    init(
        videoURL: URL,
        playbackSpeed: WallpaperDisplayPlaybackSpeed = WallpaperDisplayPlaybackSpeed.normal,
        volume: WallpaperDisplayVolume = WallpaperDisplayVolume(0),
        controlsStyle: AVPlayerViewControlsStyle = .default,
        videoGravity: AVLayerVideoGravity = .resizeAspectFill
    ) {
        self.videoURL = videoURL
        self.playbackSpeed = playbackSpeed
        self.volume = volume
        self.controlsStyle = controlsStyle
        self.videoGravity = videoGravity
    }

    var body: some View {
        Group {
            if let player {
                PlayerNSView(
                    player: player,
                    playbackSpeed: playbackSpeed,
                    volume: volume,
                    controlsStyle: controlsStyle,
                    videoGravity: videoGravity
                )
            } else {
                Color.clear
            }
        }
        .onAppear {
            let item = AVPlayerItem(url: videoURL)
            let newPlayer = AVPlayer(playerItem: item)

            loopObserver = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: item,
                queue: .main
            ) { _ in
                newPlayer.seek(to: .zero)
                newPlayer.play()
            }

            player = newPlayer
            newPlayer.play()
        }
        .onDisappear {
            player?.pause()
            if let loopObserver {
                NotificationCenter.default.removeObserver(loopObserver)
            }
        }
    }
}

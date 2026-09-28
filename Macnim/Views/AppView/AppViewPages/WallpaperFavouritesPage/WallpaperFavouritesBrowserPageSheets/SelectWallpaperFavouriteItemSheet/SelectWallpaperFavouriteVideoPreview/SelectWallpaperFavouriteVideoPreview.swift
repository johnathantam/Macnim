//
//  SelectWallpaperVideoPreview.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI
import AVKit

/// Looping preview reflecting the in-progress speed/volume settings live, before Apply is tapped.
struct SelectWallpaperFavouriteVideoPreview: View {
    let videoURL: URL
    let playbackSpeed: WallpaperDisplayPlaybackSpeed
    let volume: WallpaperDisplayVolume

    @State private var player: AVPlayer?
    @State private var loopObserver: NSObjectProtocol?
    
    init(videoURL: URL, playbackSpeed: WallpaperDisplayPlaybackSpeed, volume: WallpaperDisplayVolume) {
        self.videoURL = videoURL
        self.playbackSpeed = playbackSpeed
        self.volume = volume
    }

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .disabled(true)
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.08))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 24)
        .onAppear {
            let item = AVPlayerItem(url: videoURL)
            let newPlayer = AVPlayer(playerItem: item)
            newPlayer.volume = Float(volume.value)
            newPlayer.rate = Float(playbackSpeed.rawValue)
            newPlayer.play()

            loopObserver = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: item,
                queue: .main
            ) { _ in
                newPlayer.seek(to: .zero)
                newPlayer.rate = Float(playbackSpeed.rawValue)
            }

            player = newPlayer
        }
        .onChange(of: playbackSpeed) { _, newValue in
            player?.rate = Float(newValue.rawValue)
        }
        .onChange(of: volume) { _, newValue in
            player?.volume = Float(newValue.value)
        }
        .onDisappear {
            player?.pause()
            if let loopObserver {
                NotificationCenter.default.removeObserver(loopObserver)
            }
        }
    }
}

//
//  SelectWallpaperVideoPreview.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI
import AVKit

/// Looping preview reflecting the in-progress speed/volume settings live, before Apply is tapped.
struct SelectWallpaperVideoPreview: View {
    let videoURL: URL
    let playbackSpeed: Double
    let volume: Double

    @State private var player: AVPlayer?
    @State private var loopObserver: NSObjectProtocol?

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
            newPlayer.volume = Float(volume)
            newPlayer.rate = Float(playbackSpeed)
            newPlayer.play()

            loopObserver = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: item,
                queue: .main
            ) { _ in
                newPlayer.seek(to: .zero)
                newPlayer.rate = Float(playbackSpeed)
            }

            player = newPlayer
        }
        .onChange(of: playbackSpeed) { _, newValue in
            player?.rate = Float(newValue)
        }
        .onChange(of: volume) { _, newValue in
            player?.volume = Float(newValue)
        }
        .onDisappear {
            player?.pause()
            if let loopObserver {
                NotificationCenter.default.removeObserver(loopObserver)
            }
        }
    }
}

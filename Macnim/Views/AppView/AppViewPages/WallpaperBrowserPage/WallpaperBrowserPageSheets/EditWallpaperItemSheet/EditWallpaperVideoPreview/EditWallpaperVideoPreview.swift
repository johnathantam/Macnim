//
//  EditWallpaperVideoPreview.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import SwiftUI
import AVKit

/// Read-only looping preview of the wallpaper's current video, shown in the edit sheet.
/// Reflects the in-progress `muted`/`playbackSpeed` edits live, before they're saved.
struct EditWallpaperVideoPreview: View {
    let videoURL: URL
    let muted: Bool
    let playbackSpeed: Double

    @State private var player: AVPlayer?
    @State private var loopObserver: NSObjectProtocol?

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .disabled(true) // display-only — no scrubbing/controls interaction
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
            newPlayer.isMuted = muted
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
        .onChange(of: muted) { _, newValue in
            player?.isMuted = newValue
        }
        .onChange(of: playbackSpeed) { _, newValue in
            player?.rate = Float(newValue)
        }
        .onDisappear {
            player?.pause()
            if let loopObserver {
                NotificationCenter.default.removeObserver(loopObserver)
            }
        }
    }
}

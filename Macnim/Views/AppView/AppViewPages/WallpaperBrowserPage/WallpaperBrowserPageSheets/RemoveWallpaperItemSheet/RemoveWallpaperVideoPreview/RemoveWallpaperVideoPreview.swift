//
//  RemoveWallpaperVideoPreview.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-21.
//

import SwiftUI
import AVKit

struct RemoveWallpaperVideoPreview: View {
    
    let videoURL: URL
    
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
            
            newPlayer.isMuted = true
            newPlayer.play()
            
            loopObserver = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: item,
                queue: .main
            ) { _ in
                newPlayer.seek(to: .zero)
                newPlayer.play()
            }
            
            player = newPlayer
        }
        .onDisappear {
            player?.pause()
            
            if let loopObserver {
                NotificationCenter.default.removeObserver(loopObserver)
            }
        }
    }
}

#Preview {
    RemoveWallpaperVideoPreview(
        videoURL: Bundle.main.url(
            forResource: "test-wallpaper",
            withExtension: "mp4"
        )!
    )
    .frame(width: 420)
    .padding()
}

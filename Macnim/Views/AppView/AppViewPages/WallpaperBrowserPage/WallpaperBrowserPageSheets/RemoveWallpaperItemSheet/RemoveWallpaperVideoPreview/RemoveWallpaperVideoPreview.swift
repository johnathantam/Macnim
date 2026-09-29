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
    let playbackSpeed: WallpaperDisplayPlaybackSpeed
    let volume: WallpaperDisplayVolume
    
    init(
        videoURL: URL,
        playbackSpeed: WallpaperDisplayPlaybackSpeed,
        volume: WallpaperDisplayVolume
    ) {
        self.videoURL = videoURL
        self.playbackSpeed = playbackSpeed
        self.volume = volume
    }

    var body: some View {
        LoopingVideoPlayer(
            videoURL: videoURL,
            playbackSpeed: playbackSpeed,
            volume: volume,
        )
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 24)
    }
}

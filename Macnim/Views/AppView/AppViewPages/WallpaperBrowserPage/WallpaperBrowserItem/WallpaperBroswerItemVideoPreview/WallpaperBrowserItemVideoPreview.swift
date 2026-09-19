//
//  WallpaperBrowserItemVideoPreview.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-15.
//

import SwiftUI
import AppKit

struct WallpaperBrowserItemVideoPreview: NSViewRepresentable {
    private let videoURL: URL

    init(videoURL: URL) {
        self.videoURL = videoURL
    }

    func makeNSView(context: Context) -> WallpaperBrowserItemVideoPlayer {
        WallpaperBrowserItemVideoPlayer(videoURL: videoURL)
    }

    func updateNSView(_ nsView: WallpaperBrowserItemVideoPlayer, context: Context) {
        
    }
}

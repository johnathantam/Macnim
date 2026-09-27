//
//  WallpaperSelectionPayload.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import AppKit
import Foundation

/// The playback configuration the user is choosing to apply to a wallpaper.
struct WallpaperItemDisplayPayload: Codable {
    var wallpaperItem: WallpaperItem
    var screenIDs: Set<CGDirectDisplayID>
    
    var fitStyle: WallpaperDisplayFitStyle
    var playbackSpeed: WallpaperDisplayPlaybackSpeed
    var volume: WallpaperDisplayVolume
}

//
//  WallpaperScreenManager.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import AppKit
import SwiftUI

@Observable
final class WallpaperScreenManager {
    private var wallpapers: [WallpaperScreen] = []

    init() throws {
        // loop through every screen and attach a wallpaper view
        for screen in NSScreen.screens {
            wallpapers.append(
                try WallpaperScreen(screen: screen)
            )
        }
    }
    
    public func playVideoOnScreen(displayID: CGDirectDisplayID, videoURL: URL) -> Void {
        // find the screen
        for wallpaper in wallpapers {
            if wallpaper.getDisplayID() == displayID {
                // play the video
                wallpaper.playVideo(videoURL: videoURL)
                return
            }
        }
    }
}

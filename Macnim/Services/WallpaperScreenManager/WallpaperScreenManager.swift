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
    private var wallpaperScreens: [WallpaperScreen] = []

    init() throws {
        // loop through every screen and attach a wallpaper view
        for screen in NSScreen.screens {
            wallpaperScreens.append(
                try WallpaperScreen(screen: screen)
            )
        }
    }
    
    public func playVideoOnScreen(displayID: CGDirectDisplayID, videoURL: URL) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // play the video
                wallpaperScreen.playVideo(videoURL: videoURL)
                return
            }
        }
    }
    
    public func showScreen(displayID: CGDirectDisplayID) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // play the video
                wallpaperScreen.show()
                return
            }
        }
    }

    public func hideScreen(displayID: CGDirectDisplayID) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // play the video
                wallpaperScreen.hide()
                return
            }
        }
    }
}

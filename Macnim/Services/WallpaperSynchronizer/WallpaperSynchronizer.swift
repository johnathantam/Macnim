//
//  WallpaperSynchronizer.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-26.
//

import Foundation
import AppKit

struct WallpaperSynchronizer {
    static func sync(wallpaperRepository: WallpaperRepository, wallpaperScreenManager: WallpaperScreenManager) {
        for wallpaperItemDisplay in wallpaperRepository.getWallpaperItemDisplays() {
            guard let wallpaperScreen = wallpaperScreenManager.getScreens().first(where: { screen in
                let displayID = screen.getDisplayID()
                guard let displayCFUUID = CGDisplayCreateUUIDFromDisplayID(displayID) else {
                    return false
                }
                let cfUUIDBytes = CFUUIDGetUUIDBytes(displayCFUUID.takeRetainedValue())
                let displayUUID = UUID(uuid: unsafeBitCast(cfUUIDBytes, to: uuid_t.self))

                return displayUUID == wallpaperItemDisplay.displayUUID
            }) else {
                continue
            }
            
            let displayID = wallpaperScreen.getDisplayID()
            let wallpaperItem = wallpaperItemDisplay.wallpaperItem
            
            wallpaperScreenManager.playVideoOnScreen(displayID: displayID, videoURL: wallpaperItem.videoURL)
            wallpaperScreenManager.showScreen(displayID: displayID)
            
            wallpaperScreenManager.setFitStyleOnScreen(displayID: displayID,newFitStyle: wallpaperItemDisplay.fitStyle)
            wallpaperScreenManager.setPlaybackSpeedOnScreen(displayID: displayID,newPlaybackSpeed: wallpaperItemDisplay.playbackSpeed)
            wallpaperScreenManager.setVolumeOnScreen(displayID: displayID, newVolume: wallpaperItemDisplay.volume)
        }
    }
}

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
            wallpaperScreens.append(try WallpaperScreen(screen: screen))
        }
    }
    
    public func getScreens() -> [WallpaperScreen] {
        return self.wallpaperScreens
    }
    
    public func setFitStyleOnScreen(displayID: CGDirectDisplayID, newFitStyle: WallpaperDisplayFitStyle) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // play the video
                wallpaperScreen.setFitStyle(newFitStyle: newFitStyle)
                return
            }
        }
    }
    
    public func setPlaybackSpeedOnScreen(displayID: CGDirectDisplayID, newPlaybackSpeed: WallpaperDisplayPlaybackSpeed) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // play the video
                wallpaperScreen.setPlaybackSpeed(newPlaybackSpeed: newPlaybackSpeed)
                return
            }
        }
    }
    
    public func setVolumeOnScreen(displayID: CGDirectDisplayID, newVolume: WallpaperDisplayVolume) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // play the video
                wallpaperScreen.setVolume(newVolume: newVolume)
                return
            }
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
    
    public func pauseVideoOnScreen(displayID: CGDirectDisplayID) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // pause the video
                wallpaperScreen.pauseVideo()
                return
            }
        }
    }
    
    public func clearVideoOnScreen(displayID: CGDirectDisplayID) -> Void {
        // find the screen
        for wallpaperScreen in wallpaperScreens {
            if wallpaperScreen.getDisplayID() == displayID {
                // pause the video
                wallpaperScreen.clearVideo()
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
    
    public func syncWallpaperRepository(from wallpaperRepository: WallpaperRepository) {
        for wallpaperItemDisplay in wallpaperRepository.getWallpaperItemDisplays() {
            guard let wallpaperScreen = wallpaperScreens.first(where: { screen in
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
            
            playVideoOnScreen(displayID: displayID, videoURL: wallpaperItem.videoURL)
            showScreen(displayID: displayID)
            
            setFitStyleOnScreen(displayID: displayID,newFitStyle: wallpaperItemDisplay.fitStyle)
            setPlaybackSpeedOnScreen(displayID: displayID,newPlaybackSpeed: wallpaperItemDisplay.playbackSpeed)
            setVolumeOnScreen(displayID: displayID, newVolume: wallpaperItemDisplay.volume)
        }
    }
}

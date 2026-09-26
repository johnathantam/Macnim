//
//  WallpaperScreen.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//

import AppKit
import SwiftUI

struct WallpaperScreenError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}

final class WallpaperScreen: Identifiable {
    private var screen: NSScreen
    private var displayID: CGDirectDisplayID
    private var window: NSWindow
    private var videoView: WallpaperScreenVideoView
    
    init(screen: NSScreen) throws {
        self.screen = screen
        
        guard let displayID = screen.deviceDescription[
            NSDeviceDescriptionKey("NSScreenNumber")
        ] as? CGDirectDisplayID else {
            throw WallpaperScreenError("Could not determine screen ID")
        }
        
        self.displayID = displayID
        self.videoView = WallpaperScreenVideoView()
        self.window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.ignoresMouseEvents = true
        window.isMovableByWindowBackground = false
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        // Tell AppKit this window shouldn't count as a normal app window:
        // stays out of Cmd+` cycling, the Window menu, Mission Control's app
        // switcher, and — critically — the "does this app have visible windows"
        // check that Dock-icon-click reopening relies on.
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.isExcludedFromWindowsMenu = true
        window.isReleasedWhenClosed = false
        window.hidesOnDeactivate = false
        window.isRestorable = false
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle
        ]

        window.contentView = videoView
    }
    
    public func getDisplayID() -> CGDirectDisplayID {
        return self.displayID
    }
    
    public func getFrame() -> NSRect {
        return self.screen.frame
    }
    
    public func getLocalizedName() -> String {
        return self.screen.localizedName
    }
    
    public func getFitStyle() -> WallpaperDisplayFitStyle {
        return videoView.getFitStyle()
    }

    public func setFitStyle(newFitStyle: WallpaperDisplayFitStyle) {
        videoView.setFitStyle(newFitStyle: newFitStyle)
    }

    public func getVolume() -> WallpaperDisplayVolume {
        return videoView.getVolume()
    }

    public func setVolume(newVolume: WallpaperDisplayVolume) {
        videoView.setVolume(newVolume: newVolume)
    }

    public func getPlaybackSpeed() -> WallpaperDisplayPlaybackSpeed {
        return videoView.getPlaybackSpeed()
    }

    public func setPlaybackSpeed(newPlaybackSpeed: WallpaperDisplayPlaybackSpeed) {
        videoView.setPlaybackSpeed(newPlaybackSpeed: newPlaybackSpeed)
    }
    
    public func isMain() -> Bool {
        return self.screen == NSScreen.main
    }
    
    public func isActive() -> Bool {
        return self.videoView.isPlaying()
    }

    public func playVideo(videoURL: URL) -> Void {
        videoView.play(videoURL: videoURL)
    }
    
    public func pauseVideo() -> Void {
        videoView.pause()
    }
    
    public func show() -> Void {
        window.orderFront(nil)
    }
    
    public func hide() -> Void {
        window.orderOut(nil)
    }
}

//
//  WallpaperScreen.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//

import AppKit
import SwiftUI

final class WallpaperScreen {
    private var screen: NSScreen
    private var displayID: CGDirectDisplayID
    private var window: NSWindow
    private var videoView: WallpaperScreenVideoView

    init(screen: NSScreen) {
        self.screen = screen
        
        self.displayID = screen.deviceDescription[
            NSDeviceDescriptionKey("NSScreenNumber")
        ] as! CGDirectDisplayID
        
        self.window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        self.videoView = WallpaperScreenVideoView()

        window.ignoresMouseEvents = true
        window.isMovableByWindowBackground = false
        window.level = NSWindow.Level(
            rawValue: Int(CGWindowLevelForKey(.desktopWindow))
        )

        window.contentView = videoView
        window.orderFront(nil)
    }
    
    public func getDisplayID() -> CGDirectDisplayID {
        return self.displayID
    }

    public func playVideo(videoURL: URL) -> Void {
        videoView.play(videoURL: videoURL)
    }
}

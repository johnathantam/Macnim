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

final class WallpaperScreen {
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
        window.level = NSWindow.Level(
            rawValue: Int(CGWindowLevelForKey(.desktopWindow))
        )

        window.contentView = videoView
    }
    
    public func getDisplayID() -> CGDirectDisplayID {
        return self.displayID
    }

    public func playVideo(videoURL: URL) -> Void {
        videoView.play(videoURL: videoURL)
    }
    
    public func show() -> Void {
        window.orderFront(nil)
    }
    
    public func hide() -> Void {
        window.orderOut(nil)
    }
}

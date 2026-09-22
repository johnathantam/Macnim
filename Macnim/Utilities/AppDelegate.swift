//
//  AppDelegator.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-21.
//

import AppKit

// Handles delegation of the app - always brings the main app window to the front
// - we have to do this because the app has multiple windows in the background which can interfere
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Always try to bring a real app window forward, regardless of
        // whether AppKit thinks a (wallpaper) window is already visible.
        for window in NSApp.windows where !(window.isExcludedFromWindowsMenu) {
            window.makeKeyAndOrderFront(nil)
            return true
        }
        
        return true // let AppKit create a new WindowGroup window if none exist
    }
}

//
//  AppDelegator.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-21.
//

import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var mainWindow: NSWindow?
    private var errorWindow: NSWindow?

    private var appSettings: AppSettings!
    private var wallpaperRepository: WallpaperRepository!
    private var wallpaperScreenManager: WallpaperScreenManager!

    // MARK: - Application Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        do {
            try initializeApplication()
        } catch {
            handleStartupError(error)
        }
    }

    func applicationShouldHandleReopen(
        _ sender: NSApplication,
        hasVisibleWindows flag: Bool
    ) -> Bool {
        openMainWindow()
        return true
    }

    // MARK: - Application Setup

    private func initializeApplication() throws {
        appSettings = AppSettings()
        wallpaperRepository = try WallpaperRepository()
        wallpaperScreenManager = try WallpaperScreenManager()

        WallpaperSynchronizer.sync(
            wallpaperRepository: wallpaperRepository,
            wallpaperScreenManager: wallpaperScreenManager
        )
    }

    // MARK: - Main Window

    private func openMainWindow() {
        if let mainWindow {
            mainWindow.makeKeyAndOrderFront(nil)
        } else {
            mainWindow = createMainWindow()
            mainWindow?.makeKeyAndOrderFront(nil)
        }

        NSApp.activate(ignoringOtherApps: true)
    }

    private func createMainWindow() -> NSWindow {
        let contentView = AppView()
            .environment(appSettings)
            .environment(wallpaperRepository)
            .environment(wallpaperScreenManager)
            .preferredColorScheme(appSettings.getAppearance().colorScheme)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 600),
            styleMask: [
                .titled,
                .closable,
                .miniaturizable,
                .resizable,
                .fullSizeContentView
            ],
            backing: .buffered,
            defer: false
        )

        window.title = "Macnim"
        window.contentViewController = NSHostingController(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.setContentSize(NSSize(width: 900, height: 600))
        window.center()

        return window
    }

    // MARK: - Errors

    private func handleStartupError(_ error: Error) {
        let contentView = AppErrorView(error: error)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        window.title = "Macnim"
        window.contentViewController = NSHostingController(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.setContentSize(NSSize(width: 800, height: 600))
        window.center()

        errorWindow = window

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

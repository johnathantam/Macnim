//
//  MacnimApp.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//

import SwiftUI
import AppKit

@main
struct MacnimApp: App {
    @State private var wallpaperRepository = WallpaperRepository()
    @State private var wallpaperManager = WallpaperScreenManager()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(wallpaperRepository)
                .environment(wallpaperManager)
                .onAppear {
                    guard let screen = NSScreen.main else { return }
                    guard let firstWallpaper = wallpaperRepository.items.first else { return }

                    let displayID = screen.deviceDescription[
                        NSDeviceDescriptionKey("NSScreenNumber")
                    ] as! CGDirectDisplayID

                    wallpaperManager.playVideoOnScreen(
                        displayID: displayID,
                        videoURL: firstWallpaper.videoURL
                    )
                }
        }
    }
}

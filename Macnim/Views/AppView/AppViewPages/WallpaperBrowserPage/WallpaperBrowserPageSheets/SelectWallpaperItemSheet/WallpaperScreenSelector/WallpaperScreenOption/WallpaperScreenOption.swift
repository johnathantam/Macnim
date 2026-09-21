//
//  WallpaperScreenOption.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import AppKit

/// A lightweight, Identifiable/Hashable wrapper around NSScreen, since NSScreen
/// itself doesn't conform to either and can't be used directly in SwiftUI selection state.
struct WallpaperScreenOption: Identifiable, Hashable {
    let id: CGDirectDisplayID
    let name: String
    let frame: CGRect
    let isMain: Bool

    static func currentScreens() -> [WallpaperScreenOption] {
        NSScreen.screens.compactMap { screen in
            guard let displayID = screen.deviceDescription[
                NSDeviceDescriptionKey("NSScreenNumber")
            ] as? CGDirectDisplayID else {
                return nil
            }

            return WallpaperScreenOption(
                id: displayID,
                name: screen.localizedName,
                frame: screen.frame,
                isMain: screen == NSScreen.main
            )
        }
    }
}

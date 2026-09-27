//
//  WallpaperItemDisplay.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import AppKit
import Foundation

enum WallpaperDisplayFitStyle: String, CaseIterable, Identifiable, Codable {
    case fill
    case fit
    case stretch
    case center

    var id: Self { self }

    var title: String {
        switch self {
            case .fill:
                "Fill"
            case .fit:
                "Fit"
            case .stretch:
                "Stretch"
            case .center:
                "Center"
        }
    }

    var description: String {
        switch self {
            case .fill:
                "Fills the display while preserving the wallpaper's aspect ratio."
            case .fit:
                "Shows the entire wallpaper while preserving its aspect ratio."
            case .stretch:
                "Stretches the wallpaper to fill the display."
            case .center:
                "Displays the wallpaper at its original size, centered."
        }
    }
}

struct WallpaperDisplayVolume: Codable, Equatable {
    static let min: Double = 0
    static let max: Double = 1
    static let `default`: Double = 1

    var value: Double

    init(_ value: Double = Self.default) {
        self.value = Swift.min(Swift.max(value, Self.min), Self.max)
    }
}

enum WallpaperDisplayPlaybackSpeed: Double, CaseIterable, Identifiable, Codable {
    case half = 0.5
    case normal = 1.0
    case oneAndHalf = 1.5
    case double = 2.0

    var id: Self { self }

    var title: String {
        switch self {
        case .half:
            "0.5×"
        case .normal:
            "1×"
        case .oneAndHalf:
            "1.5×"
        case .double:
            "2×"
        }
    }
}

struct WallpaperItemDisplay: Identifiable, Codable {
    let id: UUID
    
    let displayUUID: UUID
    
    let wallpaperItem: WallpaperItem
    
    var fitStyle: WallpaperDisplayFitStyle = WallpaperDisplayFitStyle.fill
    var volume: WallpaperDisplayVolume = WallpaperDisplayVolume(0)
    var playbackSpeed: WallpaperDisplayPlaybackSpeed = WallpaperDisplayPlaybackSpeed.normal
}

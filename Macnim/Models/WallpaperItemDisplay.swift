//
//  WallpaperItemDisplay.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import AppKit
import Foundation

struct WallpaperItemDisplay: Identifiable, Codable {
    let id: UUID
    
    let displayUUID: UUID
    
    let wallpaperItem: WallpaperItem
    
    var volume: Double
    var playbackSpeed: Double
}

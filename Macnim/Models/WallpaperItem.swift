//
//  WallpaperItem.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import Foundation

struct WallpaperItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var videoURL: URL

    var isFavourite: Bool = false
}

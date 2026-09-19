//
//  WallpaperLibrary.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-17.
//

import Observation

@Observable
final class WallpaperRepository {
    private var wallpaperItems: [WallpaperItem]
    
    init(wallpaperItems: [WallpaperItem]) {
        self.wallpaperItems = wallpaperItems
    }
    
    func getWallpaperItems() -> [WallpaperItem] {
        return self.wallpaperItems
    }

    func add(_ item: WallpaperItem) -> Void {
        wallpaperItems.append(item)
    }

    func delete(_ item: WallpaperItem) -> Void {
        wallpaperItems.removeAll { $0.id == item.id }
    }

    func update(_ item: WallpaperItem, name: String) -> Void {
        guard let index = wallpaperItems
            .firstIndex(where: { $0.id == item.id }) else {
                return
            }
        
        wallpaperItems[index].name = name
    }
}

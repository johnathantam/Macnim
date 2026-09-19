//
//  WallpaperBrowser.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI
import AppKit

struct WallpaperBrowserPage: View {
    private var wallpaperItems: [WallpaperItem]
    @State private var searchText: String = ""
    
    init(wallpaperItems: [WallpaperItem]) {
        self.wallpaperItems = wallpaperItems
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                WallpaperBrowserItemLayout( minimumColumnWidth: 240, spacing: 8 ) {
                    ForEach(Array(wallpaperItems.enumerated()), id: \.element.id) { index, wallpaperItem in
                        // Place wallpaper item
                        WallpaperBrowserItem(wallpaper: wallpaperItem)
                        
                        // Dynamically stagger wallpaper items
                        if index == 0 {
                            WallpaperBrowserDecorativeItem(width:240, height: 100)
                        } else if index == 2 {
                            WallpaperBrowserDecorativeItem(width: 240, height: 160)
                        } else if index == 4 {
                            WallpaperBrowserDecorativeItem(width: 240, height: 100)
                        }
                    }
                }
                .padding(8)
            }
            .frame(maxWidth: .infinity)
        }
        .searchable(
            text: $searchText,
            placement: .toolbar,
            prompt: "Search wallpapers"
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // Add wallpaper
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .labelStyle(.titleAndIcon)
            }
        }

    }
}

#Preview {
    WallpaperBrowserPage(
        wallpaperItems: [
             WallpaperItem(
                id: UUID(),
                name: "Aurora",
                videoURL: Bundle.main.url(
                    forResource: "test-wallpaper",
                    withExtension: "mp4"
                )!
            ),
            WallpaperItem(
                id: UUID(),
                name: "Aurora",
                videoURL: Bundle.main.url(
                    forResource: "test-wallpaper",
                    withExtension: "mp4"
                )!
            )
        ]
    )
}

//
//  ContentView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//


import SwiftUI

struct AppView: View {
    var body: some View {
        NavigationSplitView {
            AppViewSidebar()
        } detail: {
            WallpaperBrowserPage(
                wallpaperItems: [
                    WallpaperItem(
                        id: UUID(),
                        name: "Aurora",
                        videoURL: Bundle.main.url(
                            forResource: "bell-wallpaper",
                            withExtension: "mp4"
                        )!
                    ),
                    WallpaperItem(
                        id: UUID(),
                        name: "Aurora",
                        videoURL: Bundle.main.url(
                            forResource: "smoke-wallpaper",
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
                    ),
                    WallpaperItem(
                        id: UUID(),
                        name: "Aurora",
                        videoURL: Bundle.main.url(
                            forResource: "bus-wallpaper",
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
                    ),
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
//            AddWallpaperItemView(
//                onAddWallpaperItem: { wallpaper in
//                    print("Added: \(wallpaper.name)")
//                }
//            )
        }
    }
}

#Preview {
    AppView()
}

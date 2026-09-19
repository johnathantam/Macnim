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
            WallpaperBrowserPage()
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

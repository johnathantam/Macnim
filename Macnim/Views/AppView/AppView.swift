//
//  ContentView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//


import SwiftUI

enum AppPageState {
    case wallpapers
    case favourites
    case displays
    case settings
}

struct AppView: View {
    @State private var selectedPage: AppPageState = .wallpapers

    var body: some View {
        NavigationSplitView {
            AppViewSidebar(
                selectedPage: $selectedPage
            )
        } detail: {
            switch selectedPage {
                case .wallpapers:
                    WallpaperBrowserPage()

                case .favourites:
                    WallpaperFavouritesBrowserPage()

                case .displays:
                    WallpaperDisplayPage()

                case .settings:
                    AppSettingsPage()
                }
        }
    }
}

#Preview {
    AppView()
}

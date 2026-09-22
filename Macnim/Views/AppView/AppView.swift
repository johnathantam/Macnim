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
        }
    }
}

#Preview {
    AppView()
}

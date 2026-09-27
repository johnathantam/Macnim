//
//  WallpaperFavouritesPage.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-27.
//

import SwiftUI
import AppKit

struct WallpaperFavouritesBrowserPage: View {
    @Environment(WallpaperRepository.self) private var wallpaperRepository
    @Environment(WallpaperScreenManager.self) private var wallpaperScreenManager

    // Browser action error
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Selected wallpaper
    @State private var selectedWallpaperFavouriteItem: WallpaperItem?

    // Search filter section
    @State private var searchFavouriteText: String = ""
    private var searchedWallpaperFavouriteItems: [WallpaperItem] {
        wallpaperRepository.getWallpaperItems().filter { wallpaperItem in
            wallpaperItem.isFavourite &&
            (
                searchFavouriteText.isEmpty ||
                wallpaperItem.name.localizedCaseInsensitiveContains(searchFavouriteText)
            )
        }
    }

    private func selectWallpaperItem(wallpaperItem: WallpaperItem, wallpaperItemDisplayPayload: WallpaperItemDisplayPayload) {
        do {
            for screenID in wallpaperItemDisplayPayload.screenIDs {
                guard let displayCFUUID = CGDisplayCreateUUIDFromDisplayID(screenID) else {
                    continue
                }
                let CFUUIDBytes = CFUUIDGetUUIDBytes(displayCFUUID.takeRetainedValue())
                let displayUUID = UUID(uuid: unsafeBitCast(CFUUIDBytes, to: uuid_t.self))
                
                let wallpaperItemDisplay = WallpaperItemDisplay(
                    id: UUID(),
                    displayUUID: displayUUID,
                    wallpaperItem: wallpaperItemDisplayPayload.wallpaperItem,
                    fitStyle: wallpaperItemDisplayPayload.fitStyle,
                    playbackSpeed: wallpaperItemDisplayPayload.playbackSpeed,
                    volume: wallpaperItemDisplayPayload.volume,
                )
                
                if let existingDisplay = wallpaperRepository.getWallpaperItemDisplays().first(where: { $0.displayUUID == displayUUID }) {
                    try wallpaperRepository.removeWallpaperItemDisplay(wallpaperItemDisplayId: existingDisplay.id)
                }
                
                try wallpaperRepository.addWallpaperItemDisplay(
                    wallpaperItemDisplay: wallpaperItemDisplay
                )
                
                wallpaperScreenManager.playVideoOnScreen(
                    displayID: screenID,
                    videoURL: wallpaperItemDisplayPayload.wallpaperItem.videoURL
                )
                
                wallpaperScreenManager.showScreen(
                    displayID: screenID
                )
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if searchedWallpaperFavouriteItems.isEmpty {
                WallpaperFavouritesBrowserEmptyView(
                    isSearching: !searchFavouriteText.isEmpty
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    WallpaperFavouritesBrowserItemLayout(
                        minimumColumnWidth: 240,
                        spacing: 8
                    ) {
                        ForEach(
                            Array(searchedWallpaperFavouriteItems.enumerated()),
                            id: \.element.id
                        ) { index, wallpaperFavouriteItem in

                            WallpaperFavouritesBrowserItem(
                                wallpaperFavouriteItem: wallpaperFavouriteItem,
                                onSelect: {
                                    selectedWallpaperFavouriteItem = wallpaperFavouriteItem
                                }
                            )

                            if index == 0 {
                                WallpaperFavouritesBrowserDecorativeItem(
                                    width: 240,
                                    height: 100
                                )
                            } else if index == 2 {
                                WallpaperFavouritesBrowserDecorativeItem(
                                    width: 240,
                                    height: 160
                                )
                            } else if index == 4 {
                                WallpaperFavouritesBrowserDecorativeItem(
                                    width: 240,
                                    height: 100
                                )
                            }
                        }
                    }
                    .padding(8)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .searchable(
            text: $searchFavouriteText,
            placement: .toolbar,
            prompt: "Search wallpapers"
        )
        .sheet(item: $selectedWallpaperFavouriteItem) { wallpaperFavouriteItem in
            SelectWallpaperFavouriteItemSheet(wallpaperFavouriteItem: wallpaperFavouriteItem) { wallpaperItemDisplayPayload in
                selectWallpaperItem(
                    wallpaperItem: wallpaperFavouriteItem,
                    wallpaperItemDisplayPayload: wallpaperItemDisplayPayload
                )
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }

    }
}

#Preview {
    WallpaperBrowserPage()
}

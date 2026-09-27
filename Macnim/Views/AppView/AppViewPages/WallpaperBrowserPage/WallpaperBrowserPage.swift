//
//  WallpaperBrowser.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI
import AppKit

enum WallpaperBrowserPageAction: Identifiable {
    case addWallpaper
    case selectWallpaper(WallpaperItem)
    case editWallpaper(WallpaperItem)
    case removeWallpaper(WallpaperItem)

    var id: String {
        switch self {
            case .addWallpaper:
                "add"

            case .selectWallpaper(let wallpaperItem):
                "select-\(wallpaperItem.id)"

            case .editWallpaper(let wallpaperItem):
                "edit-\(wallpaperItem.id)"

            case .removeWallpaper(let wallpaperItem):
                "remove-\(wallpaperItem.id)"
        }
    }
}

struct WallpaperBrowserPage: View {
    @Environment(WallpaperRepository.self) private var wallpaperRepository
    @Environment(WallpaperScreenManager.self) private var wallpaperScreenManager
    
    // Browser page action state
    @State private var wallpaperBrowserPageAction: WallpaperBrowserPageAction?

    // Brwoser action error
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Search filter section
    @State private var searchText: String = ""
    private var searchedWallpaperItems: [WallpaperItem] {
        guard !searchText.isEmpty else {
            return wallpaperRepository.getWallpaperItems()
        }
        
        return wallpaperRepository.getWallpaperItems().filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func addWallpaperItem(wallpaperItem: WallpaperItem) {
        do {
            try wallpaperRepository.addWallpaperItem(wallpaperItem: wallpaperItem)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func editWallpaperItem(wallpaperItem: WallpaperItem) {
        do {
            try wallpaperRepository.editWallpaperItem(newWallpaperItem: wallpaperItem)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func removeWallpaperItem(wallpaperItem: WallpaperItem) {
        do {
            try wallpaperRepository.removeWallpaperItem(wallpaperItemId: wallpaperItem.id)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func favouriteWallpaperItem(wallpaperItem: WallpaperItem) {
        var updatedWallpaperItem = wallpaperItem
        
        updatedWallpaperItem.isFavourite.toggle()
        
        do {
            try wallpaperRepository.editWallpaperItem(newWallpaperItem: updatedWallpaperItem)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
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
                    volume: wallpaperItemDisplayPayload.volume,
                    playbackSpeed: wallpaperItemDisplayPayload.playbackSpeed
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
            if searchedWallpaperItems.isEmpty {
                WallpaperBrowserEmptyView(isSearching: !searchText.isEmpty)
            } else {
                ScrollView {
                    WallpaperBrowserItemLayout( minimumColumnWidth: 240, spacing: 8 ) {
                        ForEach(Array(searchedWallpaperItems.enumerated()), id: \.element.id) { index, wallpaperItem in
                            // Place wallpaper item
                            WallpaperBrowserItem(
                                wallpaperItem: wallpaperItem,
                                
                                onSelect: {
                                    wallpaperBrowserPageAction = .selectWallpaper(wallpaperItem)
                                },
                                
                                onEdit: {
                                    wallpaperBrowserPageAction = .editWallpaper(wallpaperItem)
                                },
                                
                                onRemove: {
                                    wallpaperBrowserPageAction = .removeWallpaper(wallpaperItem)
                                },
                                
                                onFavourite: {
                                    favouriteWallpaperItem(wallpaperItem: wallpaperItem)
                                }
                            )
                            
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
                    wallpaperBrowserPageAction = .addWallpaper
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .labelStyle(.titleAndIcon)
            }
        }
        .sheet(item: $wallpaperBrowserPageAction) { action in
            switch action {
                case .addWallpaper:
                    AddWallpaperItemSheet { wallpaperItem in
                        addWallpaperItem(wallpaperItem: wallpaperItem)
                    }

                case .editWallpaper(let wallpaperItem):
                    EditWallpaperItemSheet(wallpaperItem: wallpaperItem) { wallpaperItem in
                        editWallpaperItem(wallpaperItem: wallpaperItem)
                    }

                case .removeWallpaper(let wallpaperItem):
                    RemoveWallpaperItemSheet(wallpaperItem: wallpaperItem) {
                        removeWallpaperItem(wallpaperItem: wallpaperItem)
                    }

                case .selectWallpaper(let wallpaperItem):
                    SelectWallpaperItemSheet( wallpaperItem: wallpaperItem ) { wallpaperItemDisplayPayload in
                        selectWallpaperItem(wallpaperItem: wallpaperItem, wallpaperItemDisplayPayload: wallpaperItemDisplayPayload)
                    }
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

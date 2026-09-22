//
//  WallpaperBrowser.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI
import AppKit

enum WallpaperBrowserPageAction: Identifiable {
    case add
    case select(WallpaperItem)
    case edit(WallpaperItem)
    case remove(WallpaperItem)

    var id: String {
        switch self {
            case .add:
                "add"

            case .select(let wallpaperItem):
                "select-\(wallpaperItem.id)"

            case .edit(let wallpaperItem):
                "edit-\(wallpaperItem.id)"

            case .remove(let wallpaperItem):
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
            return wallpaperRepository.wallpaperItems
        }
        
        return wallpaperRepository.wallpaperItems.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                WallpaperBrowserItemLayout( minimumColumnWidth: 240, spacing: 8 ) {
                    ForEach(Array(wallpaperRepository.wallpaperItems.enumerated()), id: \.element.id) { index, wallpaperItem in
                        // Place wallpaper item
                        WallpaperBrowserItem(
                            wallpaper: wallpaperItem,
                            
                            onSelect: {
                                wallpaperBrowserPageAction = .select(wallpaperItem)
                            },
                            
                            onEdit: {
                                wallpaperBrowserPageAction = .edit(wallpaperItem)
                            },
                            
                            onRemove: {
                                wallpaperBrowserPageAction = .remove(wallpaperItem)
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
        .searchable(
            text: $searchText,
            placement: .toolbar,
            prompt: "Search wallpapers"
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // Add wallpaper
                    wallpaperBrowserPageAction = .add
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .labelStyle(.titleAndIcon)
            }
        }
        .sheet(item: $wallpaperBrowserPageAction) { action in
            switch action {
                case .add:
                    AddWallpaperItemSheet { wallpaperItem in
                        do {
                            try wallpaperRepository.addWallpaperItem(wallpaperItem: wallpaperItem)
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }

                case .select(let wallpaperItem):
                    SelectWallpaperItemSheet( wallpaperItem: wallpaperItem ) { wallpaperItemDisplayPayload in
                        // Apply wallpaper
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
                                
                                if let existingDisplay = wallpaperRepository.wallpaperItemDisplays.first(where: { $0.displayUUID == displayUUID }) {
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

                case .edit(let wallpaperItem):
                    EditWallpaperItemSheet(wallpaperItem: wallpaperItem) { wallpaperItem in
                        // Edit wallpaper
                        do {
                            try wallpaperRepository.editWallpaperItem(newWallpaperItem: wallpaperItem)
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }

                case .remove(let wallpaperItem):
                    RemoveWallpaperItemSheet(wallpaperItem: wallpaperItem) {
                        // Remove wallpaper
                        do {
                            try wallpaperRepository.removeWallpaperItem(wallpaperItemId: wallpaperItem.id)
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
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

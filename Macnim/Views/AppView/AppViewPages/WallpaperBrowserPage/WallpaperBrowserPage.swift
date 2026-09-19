//
//  WallpaperBrowser.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI
import AppKit



struct WallpaperBrowserPage: View {
    @Environment(WallpaperRepository.self) private var wallpaperRepository
    
    // Action error
    @State private var showError = false
    @State private var errorMessage = ""

    // Crud Actions
    @State private var showAddWallpaperSheet = false
    @State private var showRemoveWallpaperSheet = false
    @State private var showEditWallpaperSheet = false
    
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
                    ForEach(Array(wallpaperRepository.getWallpaperItems().enumerated()), id: \.element.id) { index, wallpaperItem in
                        // Place wallpaper item
                        WallpaperBrowserItem(
                            wallpaper: wallpaperItem,
                            
                            onSelect: {
                                
                            },
                            
                            onEdit: {
                                showEditWallpaperSheet = true
                            },
                            
                            onRemove: {
                                showRemoveWallpaperSheet = true
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
                    showAddWallpaperSheet = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .labelStyle(.titleAndIcon)
            }
        }
        .sheet(isPresented: $showAddWallpaperSheet) {
            AddWallpaperItemSheet(onAddWallpaperItem: { wallpaperItem in
                do {
                    try wallpaperRepository.addWallpaperItem(wallpaperItem: wallpaperItem)
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            })
        }
        .sheet(isPresented: $showEditWallpaperSheet) {
            
        }
        .sheet(isPresented: $showRemoveWallpaperSheet) {
            
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

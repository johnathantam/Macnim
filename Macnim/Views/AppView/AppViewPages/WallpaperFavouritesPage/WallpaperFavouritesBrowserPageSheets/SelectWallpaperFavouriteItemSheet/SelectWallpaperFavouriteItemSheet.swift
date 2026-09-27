//
//  SelectWallpaperItemSheet.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI
import AppKit


struct SelectWallpaperFavouriteItemSheet: View {
    @Environment(\.dismiss) private var dismiss

    private var wallpaperFavouriteItem: WallpaperItem
    
    private var onApply: (WallpaperItemDisplayPayload) -> Void

    @State private var selectedScreenIDs: Set<CGDirectDisplayID>
    
    @State private var fitStyle: WallpaperDisplayFitStyle = WallpaperDisplayFitStyle.fill
    @State private var playbackSpeed: WallpaperDisplayPlaybackSpeed = WallpaperDisplayPlaybackSpeed.normal
    @State private var volume: WallpaperDisplayVolume = WallpaperDisplayVolume(0)

    private var canApply: Bool {
        !selectedScreenIDs.isEmpty
    }

    init(wallpaperFavouriteItem: WallpaperItem, onApply: @escaping (WallpaperItemDisplayPayload) -> Void) {
        self.wallpaperFavouriteItem = wallpaperFavouriteItem
        self.onApply = onApply
        
        // Default to every connected screen selected, matching how most
        // system wallpaper pickers behave out of the box.
        _selectedScreenIDs = State(initialValue: Set(WallpaperScreenOption.currentScreens().map(\.id)))
    }

    private func applyWallpaper() {
        onApply(
            WallpaperItemDisplayPayload(
                wallpaperItem: wallpaperFavouriteItem,
                screenIDs: selectedScreenIDs,
                fitStyle: fitStyle,
                playbackSpeed: playbackSpeed,
                volume: volume
            )
        )
        
        dismiss()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                SelectWallpaperFavouriteItemHeader(
                    wallpaperFavouriteName: wallpaperFavouriteItem.name,
                    onClose: { dismiss() }
                )

                SelectWallpaperFavouriteVideoPreview(
                    videoURL: wallpaperFavouriteItem.videoURL,
                    playbackSpeed: playbackSpeed,
                    volume: volume
                )
                
                VStack(alignment: .leading, spacing: 24) {
                    WallpaperFavouriteScreenSelector(selectedScreenIDs: $selectedScreenIDs)
                    SelectWallpaperFavouriteFitStylePicker(selection: $fitStyle)
                    WallpaperFavouritePlaybackSpeedSelector(playbackSpeed: $playbackSpeed)
                    WallpaperFavouriteVolumeSelector(volume: $volume)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }

            SelectWallpaperFavouriteItemFooter(
                canApply: canApply,
                onCancel: { dismiss() },
                onApply: applyWallpaper
            )
        }
        .frame(
            minWidth: 420,
            idealWidth: 480,
            maxWidth: 640,
            minHeight: 500,
        )
    }
}

#Preview {
    SelectWallpaperItemSheet(
        wallpaperItem: WallpaperItem(
            id: UUID(),
            name: "Aurora",
            videoURL: Bundle.main.url(forResource: "test-wallpaper", withExtension: "mp4")!
        )
    ) { settings in
        print("Applying to \(settings.screenIDs.count) screen(s), \(settings.playbackSpeed)×, volume \(settings.volume)")
    }
}

//
//  SelectWallpaperItemSheet.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI
import AppKit


struct SelectWallpaperItemSheet: View {
    @Environment(\.dismiss) private var dismiss

    private var wallpaperItem: WallpaperItem
    
    private var onApply: (WallpaperItemDisplayPayload) -> Void

    @State private var selectedScreenIDs: Set<CGDirectDisplayID>
    @State private var playbackSpeed: Double = 1.0
    @State private var volume: Double = 0.0

    private var canApply: Bool {
        !selectedScreenIDs.isEmpty
    }

    init(wallpaperItem: WallpaperItem, onApply: @escaping (WallpaperItemDisplayPayload) -> Void) {
        self.wallpaperItem = wallpaperItem
        self.onApply = onApply
        
        // Default to every connected screen selected, matching how most
        // system wallpaper pickers behave out of the box.
        _selectedScreenIDs = State(initialValue: Set(WallpaperScreenOption.currentScreens().map(\.id)))
    }

    private func applyWallpaper() {
        onApply(
            WallpaperItemDisplayPayload(
                wallpaperItem: wallpaperItem,
                screenIDs: selectedScreenIDs,
                playbackSpeed: playbackSpeed,
                volume: volume
            )
        )
        
        dismiss()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                SelectWallpaperItemHeader(
                    wallpaperName: wallpaperItem.name,
                    onClose: { dismiss() }
                )

                SelectWallpaperVideoPreview(
                    videoURL: wallpaperItem.videoURL,
                    playbackSpeed: playbackSpeed,
                    volume: volume
                )
                
                VStack(alignment: .leading, spacing: 24) {
                    WallpaperScreenSelector(selectedScreenIDs: $selectedScreenIDs)
                    WallpaperPlaybackSpeedSelector(playbackSpeed: $playbackSpeed)
                    WallpaperVolumeSelector(volume: $volume)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }

            SelectWallpaperItemFooter(
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

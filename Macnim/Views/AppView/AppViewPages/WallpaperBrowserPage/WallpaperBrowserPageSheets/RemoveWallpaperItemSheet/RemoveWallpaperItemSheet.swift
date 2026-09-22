//
//  RemoveWallpaperItemSheet.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-21.
//

import SwiftUI

struct RemoveWallpaperItemSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private var wallpaperItem: WallpaperItem
    private var onRemoveWallpaperItem: () -> Void
    
    init(
        wallpaperItem: WallpaperItem,
        onRemoveWallpaperItem: @escaping () -> Void
    ) {
        self.wallpaperItem = wallpaperItem
        self.onRemoveWallpaperItem = onRemoveWallpaperItem
    }
    
    private func removeWallpaper() {
        onRemoveWallpaperItem()
        dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Header
            RemoveWallpaperItemHeader(
                onClose: { dismiss() }
            )
            
            // Video preview
            RemoveWallpaperVideoPreview(
                videoURL: wallpaperItem.videoURL
            )
            
            // Delete warning
            HStack(alignment: .top, spacing: 14) {

                ZStack {
                    Circle()
                        .fill(.red.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: "trash.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.red)
                }

                VStack(alignment: .leading, spacing: 5) {

                    Text("Delete “\(wallpaperItem.name)”?")
                        .font(.headline)

                    Text(
                        "This will permanently remove the video file and any display assignments using it. This can't be undone."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 28)
            
            // Actions
            HStack(spacing: 8) {
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .keyboardShortcut(.cancelAction)
                .cursorHoverPointer()
                
                Button(
                    "Delete Wallpaper",
                    role: .destructive
                ) {
                    removeWallpaper()
                }
                .buttonStyle(.glassProminent)
                .tint(.red)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .cursorHoverPointer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(
            minWidth: 380,
            idealWidth: 420,
            maxWidth: 480
        )
    }
}

#Preview {
    RemoveWallpaperItemSheet(
        wallpaperItem: WallpaperItem(
            id: UUID(),
            name: "Aurora",
            videoURL: Bundle.main.url(
                forResource: "test-wallpaper",
                withExtension: "mp4"
            )!
        )
    ) {
        print("Removed")
    }
}

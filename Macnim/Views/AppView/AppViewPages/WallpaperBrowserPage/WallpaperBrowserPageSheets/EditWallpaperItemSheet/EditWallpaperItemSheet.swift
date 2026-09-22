//
//  EditWallpaperItemSheet.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import SwiftUI
import UniformTypeIdentifiers

struct EditWallpaperItemSheet: View {
    @Environment(\.dismiss) private var dismiss

    private var wallpaperItem: WallpaperItem

    private var onEditWallpaperItem: (WallpaperItem) -> Void

    // Variables to edit
    @State private var name: String

    private var canSaveWallpaperItem: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(wallpaperItem: WallpaperItem, onEditWallpaperItem: @escaping (WallpaperItem) -> Void) {
        self.wallpaperItem = wallpaperItem
        self.onEditWallpaperItem = onEditWallpaperItem
        
        _name = State(initialValue: wallpaperItem.name)
    }

    private func saveWallpaper() {
        var updatedWallpaper = wallpaperItem
        updatedWallpaper.name = name.trimmingCharacters(in: .whitespacesAndNewlines)

        onEditWallpaperItem(updatedWallpaper)
        dismiss()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            EditWallpaperItemHeader(onClose: {
                dismiss()
            })

            // Video preview — display only, not editable
            EditWallpaperVideoPreview(
                videoURL: wallpaperItem.videoURL,
                muted: true,
                playbackSpeed: 1.00
            )

            // Name input
            EditWallpaperTextInput(
                title: "Name",
                placeholder: "Northern Lights",
                value: $name
            )

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

                Button("Save Changes") {
                    saveWallpaper()
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .disabled(!canSaveWallpaperItem)
                .cursorHoverPointer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .frame(
            minWidth: 400,
            idealWidth: 460,
            maxWidth: 600
        )
    }
}

#Preview {
    EditWallpaperItemSheet(
        wallpaperItem: WallpaperItem(
            id: UUID(),
            name: "Aurora",
            videoURL: Bundle.main.url(forResource: "test-wallpaper", withExtension: "mp4")!
        )
    ) { wallpaper in
        print("Saved: \(wallpaper.name)")
    }
}

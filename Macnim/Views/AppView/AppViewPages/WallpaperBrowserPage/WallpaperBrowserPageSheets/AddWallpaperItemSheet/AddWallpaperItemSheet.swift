//
//  AddWallpaperItemView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-17.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddWallpaperItemSheet: View {
    
    @Environment(\.dismiss) private var dismiss

    private var onAddWallpaperItem: (WallpaperItem) -> Void
    
    private var canAddWallpaperItem: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && videoURL != nil
    }
    
    @State private var name = ""
    @State private var videoURL: URL?

    init(onAddWallpaperItem: @escaping (WallpaperItem) -> Void) {
        self.onAddWallpaperItem = onAddWallpaperItem
    }
    
    private func chooseVideo() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.movie]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true

        if panel.runModal() == .OK {
            videoURL = panel.url
        }
    }

    private func addWallpaper() {
        guard let videoURL else { return }

        let wallpaper = WallpaperItem(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            videoURL: videoURL
        )

        onAddWallpaperItem(wallpaper)
        dismiss()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            AddWallpaperItemHeader(onClose: {
                dismiss()
            })

            // Drop zone
            AddWallpaperVideoDropZone(videoURL: $videoURL, onChoose: {
                chooseVideo()
            })
            
            // Name input
            AddWallpaperTextInput(
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

                Button("Add Wallpaper") {
                    addWallpaper()
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .disabled(!canAddWallpaperItem)
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
//    AddWallpaperItemView() { wallpaper in
//        print("Added: \(wallpaper.name)")
//    }
}

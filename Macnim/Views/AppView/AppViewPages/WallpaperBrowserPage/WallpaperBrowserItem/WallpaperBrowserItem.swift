//
//  WallpaperBrowserItem.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//


import SwiftUI
import AVFoundation

struct WallpaperBrowserItem: View {
    private var wallpaperItem: WallpaperItem

    private var onSelect: () -> Void
    private var onEdit: () -> Void
    private var onRemove: () -> Void
    private var onFavourite: () -> Void

    @State private var wallpaperThumbnail: NSImage?
    @State private var wallpaperVideoDuration: String?

    @State private var wallpaperIsHovered = false
    @State private var wallpaperIsSelected = false

    init(
        wallpaperItem: WallpaperItem,
        onSelect: @escaping () -> Void,
        onEdit: @escaping () -> Void,
        onRemove: @escaping () -> Void,
        onFavourite: @escaping () -> Void
    ) {
        self.wallpaperItem = wallpaperItem
        self.onSelect = onSelect
        self.onEdit = onEdit
        self.onRemove = onRemove
        self.onFavourite = onFavourite
    }

    private func loadThumbnail(from url: URL, at time: CMTime = CMTime(seconds: 0.5, preferredTimescale: 600)) async -> NSImage? {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true // avoids sideways/rotated thumbnails

        do {
            let cgImage = try await generator.image(at: time).image
            return NSImage(cgImage: cgImage, size: .zero)
        } catch {
            return nil
        }
    }

    private func loadDuration(from videoURL: URL) async -> String? {
        let asset = AVURLAsset(url: videoURL)
        guard let seconds = try? await asset.load(.duration).seconds, seconds.isFinite else { return nil
        }
        let totalSeconds = Int(seconds.rounded())
        return String(format: "%d:%02d", totalSeconds / 60, totalSeconds % 60)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if wallpaperIsHovered {
                // Show wallpaper video preview
                WallpaperBrowserItemVideoPreview(videoURL: wallpaperItem.videoURL)
            } else if let wallpaperThumbnail {
                // Show generated thumbnail
                Image(nsImage: wallpaperThumbnail)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                // Placeholder while generating (or if it failed)
                Image("test-thumbnail")
                    .resizable()
                    .scaledToFill()
                    .clipped()
            }

            // Top overlay row: overflow menu (leading) + duration badge (trailing)
            VStack {
                HStack {
                    if wallpaperIsHovered {
                        Menu {
                            Button("Rename…", action: onEdit)
                            Button("Delete", role: .destructive, action: onRemove)
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .menuStyle(.borderlessButton)
                        .frame(width: 27, height: 27)
                        .background(.ultraThinMaterial, in: Circle())
                        .controlSize(.extraLarge)
                        .menuIndicator(.hidden)
                        .fixedSize()
                        .padding(8)

                        Spacer()

                        if let wallpaperVideoDuration {
                            Text(wallpaperVideoDuration)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                                .padding(8)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: wallpaperIsHovered)
                
                Spacer()
            }

            HStack(spacing: 8) {
//                Image(systemName: wallpaperIsSelected ? "checkmark.circle.fill" : "circle")
//                    .font(.system(size: 14))
//                    .foregroundStyle(wallpaperIsSelected ? Color.accentColor : .secondary)
//                    .contentTransition(.symbolEffect(.replace))
                Image(systemName: wallpaperItem.isFavourite ? "star.fill" : "star")
                    .font(.system(size: 14))
                    .foregroundStyle(wallpaperItem.isFavourite ? Color.yellow : .secondary)
                    .contentTransition(.symbolEffect(.replace))

                Text(wallpaperItem.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .padding(8)
        }
        .aspectRatio(16 / 9, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .contentShape(RoundedRectangle(cornerRadius: 14))
        .onTapGesture {
            onSelect()
        }
        .contextMenu {
            Button {
                onFavourite()
            } label: {
                Label(wallpaperItem.isFavourite ? "Unfavourite" : "Favourite", systemImage: wallpaperItem.isFavourite ? "star.slash" : "star")
            }

            Button {
                onEdit()
            } label: {
                Label("Renames", systemImage: "pencil")
            }

            Button(role: .destructive) {
                onRemove()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .onHover { isHovered in
            wallpaperIsHovered = isHovered
        }
        .task {
            wallpaperThumbnail = await loadThumbnail(from: wallpaperItem.videoURL)
            wallpaperVideoDuration = await loadDuration(from: wallpaperItem.videoURL)
        }
    }
}

#Preview {
    WallpaperBrowserItem(
        wallpaperItem: WallpaperItem(
            id: UUID(),
            name: "Aurora",
            videoURL: Bundle.main.url(forResource: "test-wallpaper", withExtension: "mp4")!
        ),
        onSelect: {},
        onEdit: {},
        onRemove: {},
        onFavourite: {}
    )
    .frame(width: 240)
    .padding()
}

//
//  WallpaperBrowserItem.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//


import SwiftUI
import AVFoundation

struct WallpaperFavouritesBrowserItem: View {
    private var wallpaperFavouriteItem: WallpaperItem

    private var onSelect: () -> Void

    @State private var wallpaperThumbnail: NSImage?
    @State private var wallpaperVideoDuration: String?
    @State private var wallpaperAspectRatio: CGFloat?

    @State private var wallpaperIsHovered = false
    @State private var wallpaperIsSelected = false

    init(
        wallpaperFavouriteItem: WallpaperItem,
        onSelect: @escaping () -> Void,
    ) {
        self.wallpaperFavouriteItem = wallpaperFavouriteItem
        self.onSelect = onSelect
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
    
    private func loadAspectRatio(from videoURL: URL) async -> CGFloat? {
        let asset = AVURLAsset(url: videoURL)
        guard let track = try? await asset.loadTracks(withMediaType: .video).first else {
            return 16.0 / 9.0
        }
        guard let naturalSize = try? await track.load(.naturalSize),
              let preferredTransform = try? await track.load(.preferredTransform) else {
            return 16.0 / 9.0
        }

        // Apply the transform so rotated (e.g. portrait-recorded) video reports correct orientation
        let transformedSize = naturalSize.applying(preferredTransform)
        let width = abs(transformedSize.width)
        let height = abs(transformedSize.height)

        guard width > 0, height > 0 else {
            return 16.0 / 9.0
        }
        
        return width / height
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if wallpaperIsHovered {
                // Show wallpaper video preview
                WallpaperBrowserItemVideoPreview(videoURL: wallpaperFavouriteItem.videoURL)
            } else if let wallpaperThumbnail {
                // Show generated thumbnail
                Image(nsImage: wallpaperThumbnail)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                // Placeholder while generating (or if it failed)
                WallpaperFavouritesBrowserItemEmptyThumbnailView()
            }

            // Top overlay row: overflow menu (leading) + duration badge (trailing)
            VStack {
                HStack {
                    Spacer()
                    
                    if wallpaperIsHovered {
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
                Image(systemName: wallpaperFavouriteItem.isFavourite ? "star.fill" : "star")
                    .font(.system(size: 14))
                    .foregroundStyle(wallpaperFavouriteItem.isFavourite ? Color.blue : .secondary)
                    .contentTransition(.symbolEffect(.replace))

                Text(wallpaperFavouriteItem.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .padding(8)
        }
        .aspectRatio(wallpaperAspectRatio, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .contentShape(RoundedRectangle(cornerRadius: 14))
        .onTapGesture {
            onSelect()
        }
        .onHover { isHovered in
            wallpaperIsHovered = isHovered
        }
        .task {
            wallpaperThumbnail = await loadThumbnail(from: wallpaperFavouriteItem.videoURL)
            wallpaperVideoDuration = await loadDuration(from: wallpaperFavouriteItem.videoURL)
            if let ratio = await loadAspectRatio(from: wallpaperFavouriteItem.videoURL) {
                wallpaperAspectRatio = ratio
            }
        }
    }
}

#Preview {
    WallpaperFavouritesBrowserItem(
        wallpaperFavouriteItem: WallpaperItem(
            id: UUID(),
            name: "Aurora",
            videoURL: Bundle.main.url(forResource: "test-wallpaper", withExtension: "mp4")!,
        ),
        onSelect: {},
    )
    .frame(width: 240)
    .padding()
}

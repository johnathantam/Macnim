//
//  WallpaperBrowserItem.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI
import AVFoundation

struct WallpaperBrowserItem: View {
    private var wallpaper: WallpaperItem
    
    @State private var wallpaperThumbnail: NSImage?
    @State private var wallpaperVideoDuration: String?
    
    @State private var wallpaperIsHovered = false
    @State private var wallpaperIsSelected = false

    init(wallpaper: WallpaperItem) {
        self.wallpaper = wallpaper
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
                WallpaperBrowserItemVideoPreview(videoURL: wallpaper.videoURL)
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

            // Duration badge, top-trailing
            VStack {
                HStack {
                    Spacer()
                    if let wallpaperVideoDuration {
                        Text(wallpaperVideoDuration)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 6))
                            .padding(8)
                    }
                }
                Spacer()
            }

            HStack(spacing: 8) {
                Image(systemName: wallpaperIsSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 14))
                    .foregroundStyle(wallpaperIsSelected ? Color.accentColor : .secondary)
                    .contentTransition(.symbolEffect(.replace))

                Text(wallpaper.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
        .aspectRatio(16 / 9, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .onHover { isHovered in
            wallpaperIsHovered = isHovered
        }
        .task {
            wallpaperThumbnail = await loadThumbnail(from: wallpaper.videoURL)
            wallpaperVideoDuration = await loadDuration(from: wallpaper.videoURL)
        }
    }
}

#Preview {
    
}

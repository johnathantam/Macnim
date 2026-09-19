//
//  VideoDropZone.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-17.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddWallpaperVideoDropZone: View {
    @Binding private var videoURL: URL?
    private var onChoose: () -> Void

    @State private var isHovering = false
    @State private var isTargeted = false
    
    init(videoURL: Binding<URL?>, onChoose: @escaping () -> Void) {
        self._videoURL = videoURL
        self.onChoose = onChoose
    }
    
    var body: some View {
        Button(action: onChoose) {
            VStack(spacing: 10) {
                if let videoURL {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(.green)
                    Text(videoURL.lastPathComponent)
                        .font(.callout.weight(.medium))
                        .lineLimit(1)
                    Text("Click to change")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Image(systemName: "arrow.down.doc")
                        .font(.system(size: 26))
                        .foregroundStyle(.secondary)
                    Text("Drag a video here")
                        .font(.callout.weight(.medium))
                    Text("or click to browse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 170)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isTargeted ? Color.accentColor.opacity(0.08)
                                     : Color.gray.opacity(isHovering ? 0.08 : 0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(
                        isTargeted ? Color.accentColor : Color.gray.opacity(0.3),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6])
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
        .onHover { hovering in
            isHovering = hovering
            if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
        }
        .onDrop(of: [.movie], isTargeted: $isTargeted) { providers in
            guard let provider = providers.first else { return false }
            _ = provider.loadObject(ofClass: URL.self) { url, _ in
                guard let url else { return }
                DispatchQueue.main.async { videoURL = url }
            }
            return true
        }
    }
}

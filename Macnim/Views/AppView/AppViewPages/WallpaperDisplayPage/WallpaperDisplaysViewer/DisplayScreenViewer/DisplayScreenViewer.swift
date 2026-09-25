//
//  WallpaperScreenOptionCard.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct DisplayScreenViewer: View {
    private let screen: WallpaperScreen
    private let isSelected: Bool
    private let onSelection: () -> Void

    @State private var isHovering = false
    @State private var isPulsing = false

    init(screen: WallpaperScreen, isSelected: Bool, onSelection: @escaping () -> Void) {
        self.screen = screen
        self.isSelected = isSelected
        self.onSelection = onSelection
    }

    private var aspectRatio: CGFloat {
        screen.getFrame().width / max(screen.getFrame().height, 1)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }

    var body: some View {
        Button(action: onSelection) {
            VStack(spacing: 6) {
                screenPreview
                    .frame(maxWidth: .infinity)

                VStack(spacing: 1) {
                    Text(screen.getLocalizedName())
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    if screen.isMain() {
                        Text("Main Display")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .cursorHoverPointer()
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .onAppear {
            // Gentle continuous breathing animation for the active/live indicator.
            if screen.isActive() {
                withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
        }
        .accessibilityLabel(
            "\(screen.getLocalizedName()), \(screen.isActive() ? "wallpaper active" : "no signal")\(isSelected ? ", selected" : "")"
        )
    }

    private var screenPreview: some View {
        ZStack {
            baseCard

            if !screen.isActive() {
                noSignalOverlay
            } else {
                liveOverlay
            }

            if isSelected {
                selectionMark
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .clipShape(shape)
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }

    // MARK: - Base card

    private var baseCard: some View {
        shape
            .fill(
                LinearGradient(
                    colors: screen.isActive()
                        ? [Color(nsColor: .windowBackgroundColor), Color.gray.opacity(0.18)]
                        : [Color(nsColor: .windowBackgroundColor).opacity(0.6), Color.gray.opacity(0.12)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .saturation(screen.isActive() ? 1 : 0.4)
            .overlay(
                shape.strokeBorder(
                    isSelected ? Color.accentColor : Color.primary.opacity(0.08),
                    lineWidth: isSelected ? 2 : 0.75
                )
            )
            .shadow(
                color: .black.opacity(isSelected ? 0.18 : 0.08),
                radius: isSelected ? 6 : 3,
                y: 2
            )
            .scaleEffect(isHovering && !isSelected ? 1.02 : 1.0)
    }
    
    // MARK: - Inactive state

    /// A muted, dashed-border treatment that reads clearly as "disconnected"
    /// rather than reusing the same dark-scrim language as other overlays.
    private var noSignalOverlay: some View {
        ZStack {
            shape
                .fill(.black.opacity(0.35))
                .aspectRatio(aspectRatio, contentMode: .fit)

            shape
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                .foregroundStyle(.white.opacity(0.25))
                .aspectRatio(aspectRatio, contentMode: .fit)

            VStack(spacing: 4) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))

                Text("No Signal")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .tracking(0.5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
    }

    // MARK: - Active state

    /// Mirrors the No Signal layout (centered icon + label) rather than a
    /// corner pill, so the two states read as a matched pair. Expanding
    /// rings behind the icon signal that the wallpaper is animating, not
    /// just that the display is enabled.
    private var liveOverlay: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.35), lineWidth: 1.5)
                    .scaleEffect(isPulsing ? 1.7 : 1)
                    .opacity(isPulsing ? 0 : 1)

                Circle()
                    .stroke(Color.blue.opacity(0.55), lineWidth: 1.5)
                    .scaleEffect(isPulsing ? 1.35 : 1)
                    .opacity(isPulsing ? 0 : 1)

                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
            }
            .frame(width: 26, height: 26)

            Text("Live")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.blue)
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
    }

    // MARK: - Selection mark

    private var selectionMark: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 16))
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, Color.accentColor)
            .background(
                Circle()
                    .fill(.white)
                    .padding(1.5)
            )
            .padding(6)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .transition(.scale.combined(with: .opacity))
    }
}

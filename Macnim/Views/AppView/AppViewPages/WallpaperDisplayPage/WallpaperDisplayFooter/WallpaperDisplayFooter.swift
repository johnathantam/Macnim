//
//  SelectWallpaperItemFooter.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperDisplayFooter: View {
    let onApply: () -> Void
    let onClear: () -> Void

    @State private var isSaved = false
    @State private var isCleared = false

    var body: some View {
        HStack(spacing: 8) {
            Spacer()

            Button {
                onClear()

                withAnimation(.easeInOut(duration: 0.2)) {
                    isCleared = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isCleared = false
                    }
                }
            } label: {
                Label(
                    isCleared ? "Removed" : "Remove Wallpaper",
                    systemImage: isCleared ? "checkmark" : "xmark"
                )
            }
            .buttonStyle(.glass)
            .tint(.red)
            .buttonBorderShape(.capsule)
            .controlSize(.large)

            Button {
                onApply()

                withAnimation(.easeInOut(duration: 0.2)) {
                    isSaved = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSaved = false
                    }
                }
            } label: {
                Label(
                    isSaved ? "Saved" : "Save Display",
                    systemImage: isSaved
                        ? "checkmark"
                        : "square.and.arrow.down"
                )
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .keyboardShortcut(.defaultAction)
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
}

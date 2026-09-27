//
//  SelectWallpaperItemFooter.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct SelectWallpaperFavouriteItemFooter: View {
    let canApply: Bool
    let onApply: () -> Void
    let onCancel: () -> Void
    
    init(canApply: Bool, onCancel: @escaping () -> Void, onApply: @escaping () -> Void) {
        self.canApply = canApply
        self.onCancel = onCancel
        self.onApply = onApply
    }

    var body: some View {
        HStack(spacing: 8) {
            Spacer()

            Button("Cancel", action: onCancel)
                .buttonStyle(.glass)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .keyboardShortcut(.cancelAction)

            Button("Set Wallpaper", action: onApply)
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .disabled(!canApply)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
}

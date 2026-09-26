//
//  DisplayScreenPreview.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-25.
//

import SwiftUI

struct DisplayScreenPreview: View {
    let screen: WallpaperScreen
    let isSelected: Bool
    let isHovering: Bool

    @State private var isPulsing = false
    
    init(screen: WallpaperScreen, isSelected: Bool, isHovering: Bool) {
        self.screen = screen
        self.isSelected = isSelected
        self.isHovering = isHovering
    }

    private var aspectRatio: CGFloat {
        screen.getFrame().width / max(screen.getFrame().height, 1)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }

    var body: some View {
        ZStack {
            DisplayScreenBaseCard(
                isActive: screen.isActive(),
                isSelected: isSelected,
                isHovering: isHovering
            )

            if screen.isActive() {
                DisplayScreenLiveOverlay()
            } else {
                DisplayScreenInactiveOverlay()
            }

            if isSelected {
                DisplayScreenSelectionMark()
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .clipShape(shape)
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }
}

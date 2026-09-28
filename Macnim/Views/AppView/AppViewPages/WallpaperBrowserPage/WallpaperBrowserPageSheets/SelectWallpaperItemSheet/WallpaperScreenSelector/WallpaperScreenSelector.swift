//
//  WallpaperScreenSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperScreenSelector: View {
    @Environment(WallpaperScreenManager.self) private var wallpaperScreenManager
    
    @Binding var selectedScreenIDs: Set<CGDirectDisplayID>

    private func toggle(_ screen: WallpaperScreen) {
        if selectedScreenIDs.contains(screen.getDisplayID()) {
            // Keep at least one screen selected — an empty selection has nothing to apply to.
            selectedScreenIDs.remove(screen.getDisplayID())
        } else {
            selectedScreenIDs.insert(screen.getDisplayID())
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Screens")
                .font(.subheadline.weight(.medium))

            ScreenArrangementView(
                screens: wallpaperScreenManager.getScreens(),
                selectedScreenIDs: selectedScreenIDs,
                onToggle: toggle
            )
        }
    }
}


//
//  WallpaperScreenSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperScreenSelector: View {
    @Binding var selectedScreenIDs: Set<CGDirectDisplayID>

    private let screens = WallpaperScreenOption.currentScreens()

    private func toggle(_ screen: WallpaperScreenOption) {
        if selectedScreenIDs.contains(screen.id) {
            // Keep at least one screen selected — an empty selection has nothing to apply to.
            guard selectedScreenIDs.count > 1 else { return }
            selectedScreenIDs.remove(screen.id)
        } else {
            selectedScreenIDs.insert(screen.id)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Screens")
                .font(.subheadline.weight(.medium))

            ScreenArrangementView(
                screens: screens,
                selectedScreenIDs: selectedScreenIDs,
                onToggle: toggle
            )
        }
    }
}


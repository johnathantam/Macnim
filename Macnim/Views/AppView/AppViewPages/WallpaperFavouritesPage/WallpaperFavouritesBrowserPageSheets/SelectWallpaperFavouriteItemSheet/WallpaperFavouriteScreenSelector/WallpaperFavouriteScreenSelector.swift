//
//  WallpaperScreenSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperFavouriteScreenSelector: View {
    @Binding var selectedScreenIDs: Set<CGDirectDisplayID>

    private let screens = WallpaperFavouriteScreenOption.currentScreens()
 
    private func toggle(_ screen: WallpaperFavouriteScreenOption) {
        if selectedScreenIDs.contains(screen.id) {
            // Keep at least one screen selected — an empty selection has nothing to apply to.
            selectedScreenIDs.remove(screen.id)
        } else {
            selectedScreenIDs.insert(screen.id)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Screens")
                .font(.subheadline.weight(.medium))

            FavouriteScreenArrangementView(
                screens: screens,
                selectedScreenIDs: selectedScreenIDs,
                onToggle: toggle
            )
        }
    }
}


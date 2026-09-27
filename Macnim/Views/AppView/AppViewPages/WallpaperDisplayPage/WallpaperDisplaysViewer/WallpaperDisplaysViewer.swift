//
//  WallpaperScreenSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperDisplaysViewer: View {
    @Binding var selectedScreenID: CGDirectDisplayID?

    private let screens = DisplayScreen.currentScreens()

    private func select(_ screen: DisplayScreen) {
        selectedScreenID = screen.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DisplayScreensArrangementView(
                screens: screens,
                selectedScreenID: selectedScreenID,
                onSelect: select
            )
        }
    }
}


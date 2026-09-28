//
//  WallpaperScreenSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperDisplaysViewer: View {
    @Binding var selectedScreenID: CGDirectDisplayID?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DisplayScreensArrangementView(
                selectedScreenID: $selectedScreenID,
            )
        }
    }
}

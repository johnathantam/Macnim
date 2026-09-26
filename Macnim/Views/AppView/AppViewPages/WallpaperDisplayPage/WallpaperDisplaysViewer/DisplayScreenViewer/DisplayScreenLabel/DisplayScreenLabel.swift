//
//  DisplayScreenLabel.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-25.
//

import SwiftUI

struct DisplayScreenLabel: View {
    let screen: WallpaperScreen
    
    init(screen: WallpaperScreen) {
        self.screen = screen
    }

    var body: some View {
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

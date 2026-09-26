//
//  WallpaperDisplayHeader.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-24.
//

import SwiftUI

struct WallpaperDisplayHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Wallpaper Displays")
                .font(.largeTitle.weight(.bold))

            Text("Choose which displays your wallpaper appears on and how it behaves.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

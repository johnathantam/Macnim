//
//  WallpaperDisplayFitStylePicker.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-22.
//

import SwiftUI

struct SelectWallpaperFitStylePicker: View {
    @Binding var selection: WallpaperDisplayFitStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Wallpaper Fit")
                .font(.headline)

            Text("Choose how wallpapers are displayed on your screens.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Picker("Wallpaper Fit", selection: $selection) {
                ForEach(WallpaperDisplayFitStyle.allCases) { style in
                    Text(style.title)
                        .tag(style)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
}

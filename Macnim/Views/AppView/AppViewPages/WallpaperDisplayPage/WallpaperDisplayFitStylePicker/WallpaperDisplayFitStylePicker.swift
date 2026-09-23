//
//  WallpaperDisplayFitStylePicker.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-22.
//

import SwiftUI

enum WallpaperDisplayFitStyle: String, CaseIterable, Identifiable {
    case fill
    case fit
    case stretch
    case center

    var id: Self { self }

    var title: String {
        switch self {
            case .fill:
                "Fill"
            case .fit:
                "Fit"
            case .stretch:
                "Stretch"
            case .center:
                "Center"
        }
    }

    var description: String {
        switch self {
            case .fill:
                "Fills the display while preserving the wallpaper's aspect ratio."
            case .fit:
                "Shows the entire wallpaper while preserving its aspect ratio."
            case .stretch:
                "Stretches the wallpaper to fill the display."
            case .center:
                "Displays the wallpaper at its original size, centered."
        }
    }
}

struct WallpaperDisplayFitStylePicker: View {
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

//
//  SelectWallpaperItemHeader.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct SelectWallpaperFavouriteItemHeader: View {
    let wallpaperFavouriteName: String
    let onClose: () -> Void
    
    init(wallpaperFavouriteName: String, onClose: @escaping () -> Void) {
        self.wallpaperFavouriteName = wallpaperFavouriteName
        self.onClose = onClose
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Set Wallpaper")
                    .font(.title2.weight(.semibold))
                Text("Choose where “\(wallpaperFavouriteName)” should play.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 22, height: 22)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.regular)
        }
        .padding(24)
    }
}

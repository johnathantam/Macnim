//
//  WallpaperFavouritesEmptyView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-27.
//

import SwiftUI

struct WallpaperFavouritesBrowserEmptyView: View {
    let isSearching: Bool

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isSearching ? "magnifyingglass" : "heart")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)

            Text(isSearching ? "No Matching Wallpapers" : "No Favourites Yet")
                .font(.title3.weight(.semibold))

            Text(
                isSearching
                    ? "Try searching for a different wallpaper."
                    : "Favourite wallpapers to find them here."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

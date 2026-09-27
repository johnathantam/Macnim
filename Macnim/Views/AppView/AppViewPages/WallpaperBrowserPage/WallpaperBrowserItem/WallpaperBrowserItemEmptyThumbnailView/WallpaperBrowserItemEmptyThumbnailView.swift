//
//  WallpaperBrowserItemEmptyThumbnailView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-27.
//

//
//  WallpaperBrowserItemEmptyThumbnailView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-27.
//

import SwiftUI

struct WallpaperBrowserItemEmptyThumbnailView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.quaternary.opacity(0.15))

            VStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)

                Text("Preview unavailable")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    WallpaperBrowserItemEmptyThumbnailView()
        .aspectRatio(16 / 9, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(width: 240)
        .padding()
}

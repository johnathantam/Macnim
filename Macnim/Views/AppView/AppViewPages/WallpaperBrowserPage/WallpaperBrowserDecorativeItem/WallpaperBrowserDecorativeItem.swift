//
//  WallpaperBrowserDecorativeItem.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-15.
//

import SwiftUI

struct WallpaperBrowserDecorativeItem: View {
    private var width: CGFloat
    private var height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    var body: some View {
        Rectangle()
            .fill(.secondary.opacity(0.15))
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

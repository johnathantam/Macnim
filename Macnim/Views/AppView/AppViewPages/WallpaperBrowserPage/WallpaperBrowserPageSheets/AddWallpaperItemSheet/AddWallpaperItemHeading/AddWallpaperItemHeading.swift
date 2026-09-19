//
//  AddWallpaperItemHeading.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-17.
//

// AddWallpaperHeader.swift
import SwiftUI

struct AddWallpaperItemHeader: View {
    private var onClose: () -> Void
    
    init(onClose: @escaping () -> Void) {
        self.onClose = onClose
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Add Wallpaper")
                    .font(.title2.weight(.semibold))
                Text("Drop a video or browse your files.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                self.onClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 22, height: 22)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.regular)
            .cursorHoverPointer()
        }
        .padding(24)
    }
}

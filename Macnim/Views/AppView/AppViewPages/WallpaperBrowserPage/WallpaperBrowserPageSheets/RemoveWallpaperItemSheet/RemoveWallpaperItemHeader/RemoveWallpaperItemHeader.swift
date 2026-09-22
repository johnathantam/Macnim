//
//  RemoveWallpaperItemHeader.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-21.
//

import SwiftUI

struct RemoveWallpaperItemHeader: View {
    private var onClose: () -> Void

    init(onClose: @escaping () -> Void) {
        self.onClose = onClose
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Delete Wallpaper")
                    .font(.title2.weight(.semibold))
                Text("This action is permanent.")
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

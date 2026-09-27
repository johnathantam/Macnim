//
//  WallpaperScreenOptionCard.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct DisplayScreenViewer: View {
    let screen: DisplayScreen
    let isSelected: Bool
    let onTap: () -> Void

    private var aspectRatio: CGFloat {
        screen.frame.width / max(screen.frame.height, 1)
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.12))
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    isSelected ? Color.accentColor : Color.gray.opacity(0.25),
                                    lineWidth: isSelected ? 2 : 1
                                )
                        )

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.accentColor)
                            .background(Circle().fill(.white))
                            .padding(4)
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 1) {
                    Text(screen.name)
                        .font(.caption.weight(.medium))
                        .lineLimit(1)
                    if screen.isMain {
                        Text("Main Display")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .cursorHoverPointer()
    }
}

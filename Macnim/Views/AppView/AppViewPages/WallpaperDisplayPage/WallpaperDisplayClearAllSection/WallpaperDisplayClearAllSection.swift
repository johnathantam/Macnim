//
//  WallpaperDisplayClearAllSection.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-25.
//

import SwiftUI

struct WallpaperDisplayClearAllSection: View {
    let onClearAll: () -> Void
    
    @State private var isCleared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Danger Zone")
                .font(.title3.weight(.semibold))

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundStyle(.red)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Clear All Displays")
                            .font(.body.weight(.medium))

                        Text("Remove wallpapers from every display.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        onClearAll()

                        withAnimation(.easeInOut(duration: 0.2)) {
                            isCleared = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isCleared = false
                            }
                        }
                    } label: {
                        Label(
                            isCleared ? "Cleared" : "Clear all",
                            systemImage: isCleared ? "checkmark" : "xmark"
                        )
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
                    .labelStyle(.titleAndIcon)
                    .tint(.red)
                }
            }
            .padding(16)
            .background(
                .quaternary.opacity(0.15),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
    }
}

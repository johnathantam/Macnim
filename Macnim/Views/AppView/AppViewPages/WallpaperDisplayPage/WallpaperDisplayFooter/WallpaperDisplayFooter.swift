//
//  SelectWallpaperItemFooter.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperDisplayFooter: View {

    let onApply: () -> Void

    @State private var isSaved = false

    init(onApply: @escaping () -> Void) {
        self.onApply = onApply
    }

    var body: some View {
        HStack(spacing: 8) {
            Spacer()

            Button {
                onApply()

                withAnimation(.easeInOut(duration: 0.2)) {
                    isSaved = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSaved = false
                    }
                }
            } label: {
                Label(
                    isSaved ? "Saved" : "Save Display",
                    systemImage: isSaved ? "checkmark" : "square.and.arrow.down"
                )
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .keyboardShortcut(.defaultAction)
            .cursorHoverPointer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
}

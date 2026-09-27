//
//  DisplayScreenInactiveOverlay.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-25.
//

import SwiftUI

struct DisplayScreenInactiveOverlay: View {
    private let shape = RoundedRectangle(
        cornerRadius: 10,
        style: .continuous
    )

    var body: some View {
        ZStack {
            shape
                .fill(.black.opacity(0.35))

            shape
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 1, dash: [4, 3])
                )
                .foregroundStyle(.white.opacity(0.25))

            VStack(spacing: 4) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))

                Text("Not animating")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .tracking(0.5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

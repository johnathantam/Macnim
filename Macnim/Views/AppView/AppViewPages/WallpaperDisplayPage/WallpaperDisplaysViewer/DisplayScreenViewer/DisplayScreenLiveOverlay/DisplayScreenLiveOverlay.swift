//
//  DisplayScreenLiveOverlay.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-25.
//

import SwiftUI

struct DisplayScreenLiveOverlay: View {
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
            }
            .frame(width: 26, height: 26)

            Text("Live")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.blue)
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//
//  DisplayScreenBaseCard.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-25.
//

import SwiftUI

struct DisplayScreenBaseCard: View {
    let isActive: Bool
    let isSelected: Bool
    let isHovering: Bool
    
    init(isActive: Bool, isSelected: Bool, isHovering: Bool) {
        self.isActive = isActive
        self.isSelected = isSelected
        self.isHovering = isHovering
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }

    var body: some View {
        shape
            .fill(
                LinearGradient(
                    colors: isActive
                        ? [
                            Color(nsColor: .windowBackgroundColor),
                            Color.gray.opacity(0.18)
                        ]
                        : [
                            Color(nsColor: .windowBackgroundColor).opacity(0.6),
                            Color.gray.opacity(0.12)
                        ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .saturation(isActive ? 1 : 0.4)
            .overlay(
                shape.strokeBorder(
                    isSelected
                        ? Color.accentColor
                        : Color.primary.opacity(0.08),
                    lineWidth: isSelected ? 2 : 0.75
                )
            )
            .shadow(
                color: .black.opacity(isSelected ? 0.18 : 0.08),
                radius: isSelected ? 6 : 3,
                y: 2
            )
            .scaleEffect(
                isHovering && !isSelected ? 1.02 : 1
            )
    }
}

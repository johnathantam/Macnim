//
//  SidebarItem.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI
import AppKit

struct AppViewSidebarItem: View {
    private var title: String
    private var systemImage: String
    private var isSelected: Bool
    private var action: () -> Void
    
    init(title: String, systemImage: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: systemImage)
                    .font(.system(size: 14))
                    .frame(width: 24)

                Text(title)
                    .font(.system(size: 13))

                Spacer()
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                            ? .gray.opacity(0.2)
                            : .clear
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AppViewSidebarItem(
        title: "Browse",
        systemImage: "square.grid.2x2",
        isSelected: true
    ) {
        
    }
}

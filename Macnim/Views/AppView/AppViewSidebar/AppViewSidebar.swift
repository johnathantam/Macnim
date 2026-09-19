//
//  Sidebar.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI

struct AppViewSidebar: View {
    @State private var selectedItem = "Wallpapers"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Library
            Text("LIBRARY")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 14)

            Spacer()
                .frame(height: 13)

            AppViewSidebarItem(
                title: "Wallpapers",
                systemImage: "square.grid.2x2",
                isSelected: selectedItem == "Wallpapers"
            ) {
                selectedItem = "Wallpapers"
            }

            AppViewSidebarItem(
                title: "Favourites",
                systemImage: "star",
                isSelected: selectedItem == "Favourites"
            ) {
                selectedItem = "Favourites"
            }

            AppViewSidebarItem(
                title: "My Uploads",
                systemImage: "arrow.up.circle",
                isSelected: selectedItem == "My Uploads"
            ) {
                selectedItem = "My Uploads"
            }

            Spacer()
                .frame(height: 28)

            // Configuration
            Text("CONFIGURATION")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 14)

            Spacer()
                .frame(height: 10)

            AppViewSidebarItem(
                title: "Settings",
                systemImage: "gearshape",
                isSelected: selectedItem == "Settings"
            ) {
                selectedItem = "Settings"
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
    }
}

#Preview {
    AppViewSidebar()
}

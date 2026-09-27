//
//  Sidebar.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-14.
//

import SwiftUI

struct AppViewSidebar: View {
    @Binding var selectedPage: AppPageState

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
                isSelected: selectedPage == .wallpapers
            ) {
                selectedPage = .wallpapers
            }

            AppViewSidebarItem(
                title: "Favourites",
                systemImage: "star",
                isSelected: selectedPage == .favourites
            ) {
                selectedPage = .favourites
            }
            
            Spacer()
                .frame(height: 28)

            // Configuration
            Text("DISPLAYS")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 14)

            Spacer()
                .frame(height: 10)

            AppViewSidebarItem(
                title: "Display Manager",
                systemImage: "rectangle.on.rectangle.angled",
                isSelected: selectedPage == .displays
            ) {
                selectedPage = .displays
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
                isSelected: selectedPage == .settings
            ) {
                selectedPage = .settings
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
    }
}

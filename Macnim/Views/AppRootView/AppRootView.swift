//
//  AppRootView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-28.
//

import SwiftUI

struct AppRootView: View {
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        AppView()
            .preferredColorScheme(
                appSettings.getAppearance().colorScheme
            )
    }
}

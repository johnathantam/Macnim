//
//  AppSettingsPage.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-26.
//

import SwiftUI

struct AppSettingsPage: View {
    @Environment(AppSettings.self) private var appSettings

    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        @Bindable var appSettings = appSettings

        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text("Settings")
                    .font(.largeTitle.weight(.bold))

                AppStartupSetting(
                    launchAtLoginEnabled: appSettings.getLaunchAtLoginEnabled(),
                    onChange: { launchAtLoginEnabled in
                        do {
                            try appSettings.setLaunchAtLoginEnabled(launchAtLoginEnabled)
                        } catch {
                            showError = true
                            errorMessage = "Failed to change startup mode"
                        }
                    }
                )
                
                AppAppearanceSetting(
                    selectedAppearance: appSettings.getAppearance(),
                    onChangeAppearance: { newAppearance in
                        appSettings.setAppearance(newAppearance)
                    }
                )
            }
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    AppSettingsPage()
}

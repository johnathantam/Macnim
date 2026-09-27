//
//  AppStartupSetting.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-26.
//

import SwiftUI
import ServiceManagement

struct AppStartupSetting: View {
    private var launchAtLoginEnabled: Bool
    private var onChangeStartup: (Bool) -> Void
    
    init(launchAtLoginEnabled: Bool, onChangeStartup: @escaping (Bool) -> Void) {
        self.launchAtLoginEnabled = launchAtLoginEnabled
        self.onChangeStartup = onChangeStartup
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Startup")
                .font(.title3.weight(.semibold))

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Launch at Login")
                        .font(.body.weight(.medium))

                    Text("Automatically start Macnim when you log in.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Toggle(
                    "",
                    isOn: Binding(
                        get: {
                            launchAtLoginEnabled
                        },
                        set: { newValue in
                            onChangeStartup(newValue)
                        }
                    )
                )
                .labelsHidden()
                .toggleStyle(.switch)
            }
            .padding(16)
            .background(
                .quaternary.opacity(0.15),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
    }
}

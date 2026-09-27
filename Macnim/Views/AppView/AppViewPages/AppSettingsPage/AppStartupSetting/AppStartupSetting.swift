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
    private var onChange: (Bool) -> Void
    
    init(launchAtLoginEnabled: Bool, onChange: @escaping (Bool) -> Void) {
        self.launchAtLoginEnabled = launchAtLoginEnabled
        self.onChange = onChange
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
                            onChange(newValue)
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

//
//  AppAppearanceSetting.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-26.
//

import SwiftUI

struct AppAppearanceSetting: View {
    private var selectedAppearance: AppAppearance
    private var onChangeAppearance: (AppAppearance) -> Void
    
    init(selectedAppearance: AppAppearance, onChangeAppearance: @escaping (AppAppearance) -> Void) {
        self.selectedAppearance = selectedAppearance
        self.onChangeAppearance = onChangeAppearance
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Appearance")
                .font(.title3.weight(.semibold))

            Text("Choose how Macnim looks on your Mac.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Picker(
                "Appearance",
                selection: Binding(
                    get: {
                        selectedAppearance
                    },
                    set: { newAppearance in
                        onChangeAppearance(newAppearance)
                    }
                )
            ) {
                ForEach(AppAppearance.allCases) { appearance in
                    Text(appearance.label)
                        .tag(appearance)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(16)
            .background(
                .quaternary.opacity(0.15),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
    }
}

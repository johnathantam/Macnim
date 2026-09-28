//
//  EditWallpaperTextInput.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import SwiftUI

struct EditWallpaperTextInput: View {
    private let title: String
    private let placeholder: String
    @Binding private var value: String

    init( title: String, placeholder: String, value: Binding<String> ) {
        self.title = title
        self.placeholder = placeholder
        self._value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $value)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            .gray.opacity(0.2),
                            lineWidth: 1
                        )
                )
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
    }
}

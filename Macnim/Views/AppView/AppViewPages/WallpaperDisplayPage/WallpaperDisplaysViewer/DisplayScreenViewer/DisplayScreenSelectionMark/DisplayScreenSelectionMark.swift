//
//  DisplayScreenSelectionMark.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-25.
//

import SwiftUI

struct DisplayScreenSelectionMark: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 16))
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, Color.accentColor)
            .background(
                Circle()
                    .fill(.white)
                    .padding(1.5)
            )
            .padding(6)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topTrailing
            )
    }
}

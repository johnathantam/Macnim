//
//  AppErrorView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import SwiftUI

struct AppErrorView: View {

    let error: Error

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 36))
                    .symbolRenderingMode(.multicolor)

                VStack(spacing: 4) {
                    Text("Macnim Couldn't Start")
                        .font(.system(size: 15, weight: .semibold))

                    Text(error.localizedDescription)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 280)
                }
            }
            
            Spacer()

            Button("Quit Macnim") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut(.defaultAction)
            .controlSize(.large)
        }
        .frame(width: 380, height: 260)
        .background(.windowBackground)
    }
}

#Preview {
    AppErrorView(
        error: NSError(
            domain: "Macnim",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Wallpaper storage could not be created in Application Support. Check disk permissions and try again."]
        )
    )
}

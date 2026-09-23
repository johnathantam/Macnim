//
//  WallpaperVolumeSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperDisplayVolumeSelector: View {
    @Binding var volume: Double

    private var speakerIcon: String {
        switch volume {
        case 0: return "speaker.slash.fill"
        case ..<0.34: return "speaker.wave.1.fill"
        case ..<0.67: return "speaker.wave.2.fill"
        default: return "speaker.wave.3.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Volume")
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text(volume == 0 ? "Muted" : "\(Int(volume * 100))%")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                Image(systemName: speakerIcon)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .frame(width: 16)
                    .contentTransition(.symbolEffect(.replace))

                Slider(value: $volume, in: 0...1)
            }
        }
        .animation(.easeOut(duration: 0.15), value: volume)
    }
}

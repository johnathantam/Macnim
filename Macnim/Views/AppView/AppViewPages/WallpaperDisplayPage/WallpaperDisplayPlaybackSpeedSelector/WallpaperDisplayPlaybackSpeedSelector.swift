//
//  WallpaperPlaybackSpeedSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperDisplayPlaybackSpeedSelector: View {
    @Binding var playbackSpeed: Double

    private static let options: [Double] = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 2.5, 3.0]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Playback Speed")
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text(playbackSpeed.formatted(.number.precision(.fractionLength(0...2))) + "×")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Picker("Playback Speed", selection: $playbackSpeed) {
                ForEach(Self.options, id: \.self) { speed in
                    Text(speed.formatted(.number.precision(.fractionLength(0...2))) + "×")
                        .tag(speed)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }
}

//
//  WallpaperPlaybackSpeedSelector.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI

struct WallpaperPlaybackSpeedSelector: View {
    @Binding var playbackSpeed: WallpaperDisplayPlaybackSpeed

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Playback Speed")
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text(playbackSpeed.rawValue.formatted(.number.precision(.fractionLength(0...2))) + "×")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Picker("Playback Speed", selection: $playbackSpeed) {
                ForEach(WallpaperDisplayPlaybackSpeed.allCases) { speed in
                    Text(speed.title)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }
}

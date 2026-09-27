import SwiftUI

struct WallpaperDisplayPage: View {
    @Environment(WallpaperRepository.self) private var wallpaperRepository
    @Environment(WallpaperScreenManager.self) private var wallpaperScreenManager

    @State private var selectedScreenID: CGDirectDisplayID?
    @State private var selectedWallpaperDisplayFitStyle: WallpaperDisplayFitStyle = .center
    @State private var selectedWallpaperPlaybackSpeed: WallpaperDisplayPlaybackSpeed = WallpaperDisplayPlaybackSpeed.normal
    @State private var selectedWallpaperVolume: WallpaperDisplayVolume = WallpaperDisplayVolume(0)
    
    init() {
        //
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Wallpaper Displays")
                        .font(.largeTitle.weight(.bold))

                    Text("Choose which displays your wallpaper appears on and how it behaves.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // MARK: - Displays
                VStack(alignment: .leading, spacing: 12) {
                    Text("Displays")
                        .font(.title3.weight(.semibold))

                    WallpaperDisplaysViewer(
                        selectedScreenID: $selectedScreenID
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .background(
                        .quaternary.opacity(0.15),
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                }

                // MARK: - Playback
                VStack(alignment: .leading, spacing: 12) {
                    Text("Adjust Display Playback Settings")
                        .font(.title3.weight(.semibold))

                    Text("Customize how your wallpaper is displayed and played.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    VStack(spacing: 0) {
                        WallpaperDisplayFitStylePicker(
                            selection: $selectedWallpaperDisplayFitStyle
                        )
                        .padding(.vertical, 14)

                        Divider()

                        WallpaperDisplayPlaybackSpeedSelector(
                            playbackSpeed: $selectedWallpaperPlaybackSpeed
                        )
                        .padding(.vertical, 14)

                        Divider()

                        WallpaperDisplayVolumeSelector(
                            volume: $selectedWallpaperVolume
                        )
                        .padding(.vertical, 14)
                    }
                    .padding(.horizontal, 16)
                    .background(
                        .quaternary.opacity(0.15),
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                }
            }
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
        }
    }
}

#Preview {
    WallpaperDisplayPage()
}

#Preview {
    WallpaperDisplayPage()
}

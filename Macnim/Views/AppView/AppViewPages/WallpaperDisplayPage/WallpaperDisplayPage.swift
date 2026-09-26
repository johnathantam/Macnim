import SwiftUI

struct WallpaperDisplayError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}

struct WallpaperDisplayPage: View {
    @Environment(WallpaperRepository.self) private var wallpaperRepository
    @Environment(WallpaperScreenManager.self) private var wallpaperScreenManager
    
    @State private var showError = false
    @State private var errorMessage = ""

    @State private var selectedScreenID: CGDirectDisplayID?
    @State private var selectedWallpaperDisplayFitStyle: WallpaperDisplayFitStyle = .center
    @State private var selectedWallpaperPlaybackSpeed: WallpaperDisplayPlaybackSpeed = WallpaperDisplayPlaybackSpeed.normal
    @State private var selectedWallpaperVolume: WallpaperDisplayVolume = WallpaperDisplayVolume(0)
    
    private func applyWallpaperDisplay() -> Void {
        do {
            guard let selectedScreenID else {
                throw(WallpaperDisplayError("No screen selected"))
            }
            
            wallpaperScreenManager.setFitStyleOnScreen(displayID: selectedScreenID, newFitStyle: selectedWallpaperDisplayFitStyle)
            wallpaperScreenManager.setPlaybackSpeedOnScreen(displayID: selectedScreenID, newPlaybackSpeed: selectedWallpaperPlaybackSpeed)
            wallpaperScreenManager.setVolumeOnScreen(displayID: selectedScreenID, newVolume: selectedWallpaperVolume)
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveWallpaperDisplay() -> Void {
        do {
            guard let selectedScreenID else {
                throw(WallpaperDisplayError("No screen selected"))
            }
            
            // create CFUUID for the given screen then convert it to a UUID
            guard let displayCFUUID = CGDisplayCreateUUIDFromDisplayID(selectedScreenID) else {
                return
            }
            let cfUUIDBytes = CFUUIDGetUUIDBytes(displayCFUUID.takeRetainedValue())
            let displayUUID = UUID(uuid: unsafeBitCast(cfUUIDBytes, to: uuid_t.self))
            
            // use UUID to fetch a copy of the current display
            guard var newDisplay = wallpaperRepository.getWallpaperItemDisplays().first(
                where: { $0.displayUUID == displayUUID }
            ) else {
                throw(WallpaperDisplayError("Could not find current display"))
            }

            // edit display with new settings
            newDisplay.fitStyle = selectedWallpaperDisplayFitStyle
            newDisplay.playbackSpeed = selectedWallpaperPlaybackSpeed
            newDisplay.volume = selectedWallpaperVolume
            
            // save display
            try wallpaperRepository.editWallpaperItemDisplay(newWallpaperItemDisplay: newDisplay)
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    private func clearWallpaperDisplay() -> Void {
        do {
            guard let selectedScreenID else {
                throw(WallpaperDisplayError("No screen selected"))
            }
            
            // create CFUUID for the given screen then convert it to a UUID
            guard let displayCFUUID = CGDisplayCreateUUIDFromDisplayID(selectedScreenID) else {
                return
            }
            let cfUUIDBytes = CFUUIDGetUUIDBytes(displayCFUUID.takeRetainedValue())
            let displayUUID = UUID(uuid: unsafeBitCast(cfUUIDBytes, to: uuid_t.self))
            
            // use UUID to fetch a copy of the current display
            guard let currentDisplay = wallpaperRepository.getWallpaperItemDisplays().first(
                where: { $0.displayUUID == displayUUID }
            ) else {
                throw(WallpaperDisplayError("Could not find current display"))
            }

            wallpaperScreenManager.clearVideoOnScreen(displayID: selectedScreenID)
            wallpaperScreenManager.hideScreen(displayID: selectedScreenID)
            try wallpaperRepository.removeWallpaperItemDisplay(wallpaperItemDisplayId: currentDisplay.id)
            
            // Nothing should remain selected
            self.selectedScreenID = nil
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    private func clearWallpaperDisplays() {
        do {
            // Clear every active wallpaper screen
            for wallpaperScreen in wallpaperScreenManager.getScreens() {
                let displayID = wallpaperScreen.getDisplayID()

                wallpaperScreenManager.clearVideoOnScreen(displayID: displayID)
                wallpaperScreenManager.hideScreen(displayID: displayID)
            }

            // Remove every saved display assignment
            for wallpaperDisplay in wallpaperRepository.getWallpaperItemDisplays() {
                try wallpaperRepository.removeWallpaperItemDisplay(
                    wallpaperItemDisplayId: wallpaperDisplay.id
                )
            }

            // Nothing should remain selected
            selectedScreenID = nil
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                WallpaperDisplayHeader()
                
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
                        
                        WallpaperDisplayFooter(
                            onApply: {
                                applyWallpaperDisplay()
                                saveWallpaperDisplay()
                            },
                            
                            onClear: {
                                clearWallpaperDisplay()
                            },
                        )
                    }
                    .padding(.horizontal, 16)
                    .background(
                        .quaternary.opacity(0.15),
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                }
                .opacity(selectedScreenID == nil ? 0.5 : 1)
                .disabled(selectedScreenID == nil)
            }
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    WallpaperDisplayPage()
}

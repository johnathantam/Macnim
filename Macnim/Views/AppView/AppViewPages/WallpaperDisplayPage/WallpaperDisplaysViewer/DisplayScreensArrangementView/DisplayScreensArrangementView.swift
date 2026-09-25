//
//  ScreenArrangmentView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI
import AppKit

struct DisplayScreensArrangementView: View {
    @Environment(WallpaperRepository.self) private var wallpaperRepository
    @Environment(WallpaperScreenManager.self) private var wallpaperScreenManager
    
    @Binding private var selectedScreenID: CGDirectDisplayID?

    private let arrangementHeight: CGFloat = 200
    
    init(selectedScreenID: Binding<CGDirectDisplayID?>) {
        self._selectedScreenID = selectedScreenID
    }

    private var arrangementBounds: CGRect {
        wallpaperScreenManager.getScreens()
            .map { $0.getFrame() }
            .reduce(into: CGRect.null) { result, frame in
                result = result.union(frame)
            }
    }

    private func scaleFactor(for size: CGSize) -> CGFloat {
        guard !arrangementBounds.isNull else {
            return 1
        }

        let horizontalScale = size.width / arrangementBounds.width
        let verticalScale = size.height / arrangementBounds.height

        // Leave some breathing room around the arrangement.
        let scale = min(horizontalScale, verticalScale) * 0.9

        // Don't let the displays become enormous.
        return min(scale, 0.20)
    }
    
    private func screenView(
        _ screen: WallpaperScreen,
        scale: CGFloat,
        bounds: CGRect,
        containerSize: CGSize
    ) -> some View {

        let frame = screen.getFrame()

        let width = frame.width * scale
        let height = frame.height * scale

        let relativeX = (frame.midX - bounds.minX) * scale
        let relativeY = (bounds.maxY - frame.midY) * scale

        let arrangementWidth = bounds.width * scale
        let arrangementHeight = bounds.height * scale

        let offsetX = (containerSize.width - arrangementWidth) / 2
        let offsetY = (containerSize.height - arrangementHeight) / 2
        
        return DisplayScreenViewer(screen: screen, isSelected: selectedScreenID == screen.getDisplayID()) {
            selectedScreenID = screen.getDisplayID()
        }
        .frame(width: width, height: height)
        .position(
            x: offsetX + relativeX,
            y: offsetY + relativeY
        )
    }

    var body: some View {
        GeometryReader { geometry in
            let bounds = arrangementBounds
            let scale = scaleFactor(for: geometry.size)

            ZStack {
                Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedScreenID = nil
                        }
                
                ForEach(wallpaperScreenManager.getScreens()) { screen in
                    screenView(
                        screen,
                        scale: scale,
                        bounds: bounds,
                        containerSize: geometry.size
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: arrangementHeight)
    }
}

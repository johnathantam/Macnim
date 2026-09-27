//
//  ScreenArrangmentView.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-20.
//

import SwiftUI
import AppKit

struct DisplayScreensArrangementView: View {
    private var screens: [DisplayScreen]
    private var selectedScreenID: CGDirectDisplayID?
    private var onSelect: (DisplayScreen) -> Void

    private let arrangementHeight: CGFloat = 200
    
    init(
        screens: [DisplayScreen],
        selectedScreenID: CGDirectDisplayID?,
        onSelect: @escaping (DisplayScreen) -> Void
    ) {
        self.screens = screens
        self.selectedScreenID = selectedScreenID
        self.onSelect = onSelect
    }

    private var arrangementBounds: CGRect {
        screens
            .map(\.frame)
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
        let scale = min(horizontalScale, verticalScale) * 1.2

        // Don't let the displays become enormous.
        return min(scale, 0.20)
    }
    
    private func screenView(
        _ screen: DisplayScreen,
        scale: CGFloat,
        bounds: CGRect,
        containerSize: CGSize
    ) -> some View {

        let frame = screen.frame

        let width = frame.width * scale
        let height = frame.height * scale

        let relativeX = (frame.midX - bounds.minX) * scale
        let relativeY = (bounds.maxY - frame.midY) * scale

        let arrangementWidth = bounds.width * scale
        let arrangementHeight = bounds.height * scale

        let offsetX = (containerSize.width - arrangementWidth) / 2
        let offsetY = (containerSize.height - arrangementHeight) / 2

        return DisplayScreenViewer(
            screen: screen,
            isSelected: selectedScreenID == screen.id
        ) {
            onSelect(screen)
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
                ForEach(screens) { screen in
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

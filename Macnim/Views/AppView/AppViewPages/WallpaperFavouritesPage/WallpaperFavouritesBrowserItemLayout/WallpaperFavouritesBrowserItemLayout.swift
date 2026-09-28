//
//  WallpaperBrowserItemMasonryDisplay.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-15.
//

import SwiftUI

struct WallpaperFavouritesBrowserItemLayout: Layout {
    private var minimumColumnWidth: CGFloat = 200
    private var spacing: CGFloat = 8
    
    init(minimumColumnWidth: CGFloat, spacing: CGFloat) {
        self.minimumColumnWidth = minimumColumnWidth
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        let columnCount = max(1, Int((width + spacing) / (minimumColumnWidth + spacing)))
        let columnWidth = (width - CGFloat(columnCount - 1) * spacing) / CGFloat(columnCount)
        var columnHeights = Array( repeating: CGFloat(0), count: columnCount )

        for subview in subviews {
            let size = subview.sizeThatFits(ProposedViewSize(width: columnWidth, height: nil))
            let shortestColumn = columnHeights.enumerated()
                .min { $0.element < $1.element }!
                .offset

            columnHeights[shortestColumn] += size.height + spacing
        }

        let height = max(0, (columnHeights.max() ?? 0) - spacing)

        return CGSize(
            width: width,
            height: height
        )
    }
    
    func placeSubviews( in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout () ) {
        let columnCount = max(1, Int((bounds.width + spacing) / (minimumColumnWidth + spacing)))
        let columnWidth = (bounds.width - CGFloat(columnCount - 1) * spacing) / CGFloat(columnCount)
        var columnHeights = Array( repeating: bounds.minY, count: columnCount )

        for subview in subviews {
            let size = subview.sizeThatFits(ProposedViewSize(width: columnWidth, height: nil))
            let shortestColumn = columnHeights.enumerated()
                .min { $0.element < $1.element }!
                .offset
            let x = bounds.minX + CGFloat(shortestColumn) * (columnWidth + spacing)
            let y = columnHeights[shortestColumn]

            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .topLeading,
                proposal: ProposedViewSize(
                    width: columnWidth,
                    height: size.height
                )
            )

            columnHeights[shortestColumn] += size.height + spacing
        }
    }
}

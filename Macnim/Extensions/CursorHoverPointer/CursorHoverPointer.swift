//
//  cursorHoverPointer.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-17.
//

import SwiftUI

extension View {
    func cursorHoverPointer() -> some View {
        self.onHover { hovering in
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}

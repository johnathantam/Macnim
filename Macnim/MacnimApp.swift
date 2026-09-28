//
//  MacnimApp.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//

import SwiftUI

@main
struct MacnimApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

//
//  MacnimApp.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-13.
//

import SwiftUI
import AppKit

enum AppStartupState {
    case ready(
        appSettings: AppSettings,
        
        wallpaperRepository: WallpaperRepository,
        wallpaperManager: WallpaperScreenManager
    )
    
    case failed(Error)
}

@main
struct MacnimApp: App {
    @State private var appStartupState: AppStartupState
    
    init() {
        do {
            _appStartupState = State(
                initialValue: .ready(
                    appSettings: AppSettings(),
                    
                    wallpaperRepository: try WallpaperRepository(),
                    wallpaperManager: try WallpaperScreenManager()
                )
            )
        } catch {
            _appStartupState = State(
                initialValue: .failed(error)
            )
        }
    }

    var body: some Scene {
        WindowGroup {
            switch appStartupState {
                case let .ready(appSettings, wallpaperRepository, wallpaperManager):
                    AppView()
                        .environment(appSettings)
                        .environment(wallpaperRepository)
                        .environment(wallpaperManager)

                case let .failed(error):
                    AppErrorView(error: error)
            }
        }
    }
}

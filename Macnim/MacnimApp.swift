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
        wallpaperScreenManager: WallpaperScreenManager
    )
    
    case failed(Error)
}

@main
struct MacnimApp: App {
    // inject app delegation functionality
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    // track startup state
    @State private var appStartupState: AppStartupState
    
    init() {
        do {
            // settings
            let appSettings = AppSettings()
            
            // app storage
            let wallpaperRepository = try WallpaperRepository()
            
            // screen animator
            let wallpaperScreenManager = try WallpaperScreenManager()
            
            _appStartupState = State(
                initialValue: .ready(
                    appSettings: appSettings,
                    
                    wallpaperRepository: wallpaperRepository,
                    wallpaperScreenManager: wallpaperScreenManager
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
                case let .ready(appSettings, wallpaperRepository, wallpaperScreenManager):
                    AppView()
                        .environment(appSettings)
                        .environment(wallpaperRepository)
                        .environment(wallpaperScreenManager)
                        .task {
                            // sync up runtime
                            WallpaperSynchronizer.sync(
                                wallpaperRepository: wallpaperRepository,
                                wallpaperScreenManager: wallpaperScreenManager
                            )
                        }
                        .preferredColorScheme(
                            appSettings.getAppearance().colorScheme
                        )
                

                case let .failed(error):
                    AppErrorView(error: error)
            }
        }
    }
}

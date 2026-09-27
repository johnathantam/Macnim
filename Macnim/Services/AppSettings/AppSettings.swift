//
//  AppSettings.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import SwiftUI
import ServiceManagement

enum AppAppearance: String, CaseIterable, Identifiable {
    case light, dark

    var id: Self { self }

    var label: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        }
    }
}

@Observable
final class AppSettings {
    private let defaults = UserDefaults.standard

    private var launchAtLoginEnabled: Bool
    private let launchAtLoginEnabledKey = "launchAtLoginEnabled"
    
    private var appearance: AppAppearance
    private let appearanceKey = "appearance"
    
    init() {
        self.launchAtLoginEnabled = defaults.bool(forKey: launchAtLoginEnabledKey)
        
        if let rawValue = defaults.string(forKey: appearanceKey), let appearance = AppAppearance(rawValue: rawValue) {
            self.appearance = appearance
        } else {
            self.appearance = .light
        }
    }

    // MARK: - Startup
    
    public func getLaunchAtLoginEnabled() -> Bool {
        return launchAtLoginEnabled
    }

    public func setLaunchAtLoginEnabled(_ enabled: Bool) throws {
        if enabled {
            try SMAppService.mainApp.register()
        } else {
            try SMAppService.mainApp.unregister()
        }
        
        self.launchAtLoginEnabled = enabled
        defaults.set(enabled, forKey: launchAtLoginEnabledKey)
    }

    // MARK: - Appearance

    public func getAppearance() -> AppAppearance {
        return appearance
    }

    public func setAppearance(_ appearance: AppAppearance) {
        self.appearance = appearance
        defaults.set(appearance.rawValue, forKey: appearanceKey)
    }
}

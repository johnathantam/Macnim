//
//  AppSettings.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-19.
//

import SwiftUI

@Observable
final class AppSettings {
    private let defaults = UserDefaults.standard

    private let hasCompletedInitialSetupKey = "hasCompletedInitialSetup"
    private let darkModeKey = "darkMode"
    
    // MARK: - Startup

    var hasCompletedInitialSetup: Bool {
        get {
            defaults.bool(forKey: hasCompletedInitialSetupKey)
        }
        set {
            defaults.set(newValue, forKey: hasCompletedInitialSetupKey)
        }
    }

    // MARK: - Appearance

    var darkMode: Bool {
        get {
            defaults.bool(forKey: darkModeKey)
        }
        set {
            defaults.set(newValue, forKey: darkModeKey)
        }
    }
}

//
//  ApplicationManager.swift
//  Stories
//
//
//
//

import Foundation

class ApplicationManager {
    static let shared: ApplicationManager = ApplicationManager()
    private let defaults = UserDefaults.standard

    var hasSeenOfflineModeMessage: Bool {
        get {
            return defaults.bool(forKey: "hasSeenOfflineModeMessage")
        }
        set (newValue) {
            defaults.set(newValue, forKey: "hasSeenOfflineModeMessage")
        }
    }
    
    var theme: StoriesDesignTheme {
        get {
            guard let themeString = defaults.string(forKey: "theme"),
                    let theme = StoriesDesignTheme(rawValue: themeString) else {
                return .plain
            }
            return theme
        }
        set (newValue) {
            defaults.set(newValue.rawValue, forKey: "theme")
        }
    }
}

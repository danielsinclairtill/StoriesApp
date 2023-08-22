//
//  StoriesStateManager.swift
//  Stories
//
//
//
//

import Foundation

class StoriesStateManager: StoriesStateContract {
    static let shared: StoriesStateManager = StoriesStateManager()
    private let defaults = UserDefaults.standard

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

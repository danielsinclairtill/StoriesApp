//
//  SquareTakeHomeStateManager.swift
//  SquareTakeHome
//
//
//
//

import Foundation

class SquareTakeHomeStateManager: SquareTakeHomeStateContract {
    static let shared: SquareTakeHomeStateManager = SquareTakeHomeStateManager()
    private let defaults = UserDefaults.standard

    var theme: SquareTakeHomeDesignTheme {
        get {
            guard let themeString = defaults.string(forKey: "theme"),
                    let theme = SquareTakeHomeDesignTheme(rawValue: themeString) else {
                return .plain
            }
            return theme
        }
        set (newValue) {
            defaults.set(newValue.rawValue, forKey: "theme")
        }
    }
}

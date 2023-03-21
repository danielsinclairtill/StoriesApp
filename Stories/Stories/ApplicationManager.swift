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
}

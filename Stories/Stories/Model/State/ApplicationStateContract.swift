//
//  ApplicationStateContract.swift
//  Stories
//
//
//

import Foundation

protocol ApplicationStateContract: AnyObject {
    /// If the user has seen the stories in the timeline are now visible in offline mode message
    var hasSeenOfflineModeMessage: Bool { get set }
    /// The current design theme of the application.
    var theme: StoriesDesignTheme { get set }
}

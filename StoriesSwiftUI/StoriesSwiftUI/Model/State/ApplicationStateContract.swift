//
//  ApplicationStateContract.swift
//  StoriesSwiftUI
//
//  Created by Daniel Till on 2023-05-07.
//

import Foundation

protocol ApplicationStateContract: AnyObject {
    /// If the user has seen the stories in the timeline are now visible in offline mode message
    var hasSeenOfflineModeMessage: Bool { get set }
    /// The current design theme of the application.
    var theme: StoriesDesignTheme { get set }
}

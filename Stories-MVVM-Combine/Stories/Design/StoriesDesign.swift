//
//  StoriesDesign.swift
//  Stories
//
//
//
//

import Foundation
import UIKit
import Combine

class StoriesDesign {
    static let shared = StoriesDesign()
    @Published private(set) var theme: StoriesDesignTheme = .plain
    private let state: StoriesStateContract
    
    init(state: StoriesStateContract = StoriesEnvironment.shared.state) {
        self.state = state
        self.theme = state.theme
    }
    
    /// Change the theme of the design system of the application. This will update displayed components colors, fonts, dimensions, etc.
    /// - Parameter theme: The new theme to change to.
    func changeToTheme(_ theme: StoriesDesignTheme) {
        self.state.theme = theme
        self.theme = theme
    }
}

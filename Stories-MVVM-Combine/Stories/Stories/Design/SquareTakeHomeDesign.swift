//
//  SquareTakeHomeDesign.swift
//  SquareTakeHome
//
//
//
//

import Foundation
import UIKit
import Combine

class SquareTakeHomeDesign {
    static let shared = SquareTakeHomeDesign()
    @Published private(set) var theme: SquareTakeHomeDesignTheme = .plain
    private let state: SquareTakeHomeStateContract
    
    init(state: SquareTakeHomeStateContract = SquareTakeHomeEnvironment.shared.state) {
        self.state = state
        self.theme = state.theme
    }
    
    /// Change the theme of the design system of the application. This will update displayed components colors, fonts, dimensions, etc.
    /// - Parameter theme: The new theme to change to.
    func changeToTheme(_ theme: SquareTakeHomeDesignTheme) {
        self.state.theme = theme
        self.theme = theme
    }
}

//
//  StoriesDesign.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

class StoriesDesign: ObservableObject {
    static let shared = StoriesDesign()
    @Published private(set) var theme: StoriesDesignTheme
    private(set) var state: ApplicationStateContract
    
    init(state: ApplicationStateContract = StoriesEnvironment.shared.state) {
        self.theme = state.theme
        self.state = state
    }
    
    func changeToTheme(_ theme: StoriesDesignTheme) {
        state.theme = theme
        self.theme = theme
    }
}

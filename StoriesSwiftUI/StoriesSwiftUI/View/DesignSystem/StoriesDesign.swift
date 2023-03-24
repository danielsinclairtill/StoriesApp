//
//  StoriesDesign.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

class StoriesDesign: ObservableObject, DesignContract {
    static let shared = StoriesDesign()
    
    private(set) var theme: DesignTheme
    @Published private(set) var attributes: Attributes
    init(theme: DesignTheme = .plain) {
        self.theme = theme
        self.attributes = StoriesDesign.getThemeAttributesFrom(theme: theme)
    }
    
    func changeToTheme(_ theme: DesignTheme) {
        self.theme = theme
        self.attributes = StoriesDesign.getThemeAttributesFrom(theme: theme)
    }
    
    private static func getThemeAttributesFrom(theme: DesignTheme) -> Attributes {
        switch theme {
        case .plain:
            return PlainTheme()
        case .retro:
            return RetroTheme()
        }
    }
}

//
//  DesignContract.swift
//  Stories
//
//
//
//

import Foundation

public enum StoriesDesignTheme: String, CaseIterable {
    case plain
    case retro
    
    func getText() -> String {
        switch self {
        case .plain:
            return "com.test.Stories.settings.theme.plain".localized()
        case .retro:
            return "com.test.Stories.settings.theme.retro".localized()
        }
    }
    
    var attributes: Attributes {
        switch self {
        case .plain:
            return PlainTheme()
        case .retro:
            return RetroTheme()
        }
    }
}

//
//  DesignContract.swift
//  Stories
//
//
//
//

import Foundation

public enum DesignTheme: String, CaseIterable {
    case plain
    case retro
    
    func getText() -> String {
        switch self {
        case.plain:
            return "com.test.Stories.settings.theme.plain".localized()
        case .retro:
            return "com.test.Stories.settings.theme.retro".localized()
        }
    }
}

public protocol DesignContract {
    /// Current applied theme type. New themes must be appended to the enum DesignTheme.
    var theme: DesignTheme { get }
    /// Member which contains all the attributes for the current applied theme (colors, fonts, etc.).
    var attributes: Attributes { get }
}

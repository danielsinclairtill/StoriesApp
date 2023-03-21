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
}

public protocol DesignContract {
    /// Current applied theme type. New themes must be appended to the enum DesignTheme.
    var theme: DesignTheme { get }
    /// Member which contains all the attributes for the current applied theme (colors, fonts, etc.).
    var attributes: Attributes { get }
}

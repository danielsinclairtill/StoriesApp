//
//  DesignContract.swift
//  Stories
//
//
//
//

import Foundation

public enum DesignTheme {
    case plain
}

public protocol DesignContract {
    /// Current applied theme type. New themes must be appended to the enum DesignTheme.
    var theme: DesignTheme { get }
    /// Member which contains all the attributes for the current applied theme (colors, fonts, etc.).
    var attributes: Attributes { get }
}

//
//  StoriesDesignTheme.swift
//  Stories
//
//
//
//

import Foundation

public enum StoriesDesignTheme: String, CaseIterable {
    case plain
    case retro
    
    var attributes: Attributes {
        switch self {
        case .plain:
            return PlainTheme()
        case .retro:
            return RetroTheme()
        }
    }
}

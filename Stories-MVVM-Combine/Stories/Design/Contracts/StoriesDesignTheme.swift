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
    
    var attributes: Attributes {
        switch self {
        case .plain:
            return PlainTheme()
        }
    }
}

//
//  SquareTakeHomeDesignTheme.swift
//  SquareTakeHome
//
//
//
//

import Foundation

public enum SquareTakeHomeDesignTheme: String, CaseIterable {
    case plain
    
    var attributes: Attributes {
        switch self {
        case .plain:
            return PlainTheme()
        }
    }
}

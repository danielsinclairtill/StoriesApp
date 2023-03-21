//
//  Theme.swift
//  Stories
//
//
//
//

import Foundation

protocol Theme {
    associatedtype Color: Colors
    associatedtype Font: Fonts
    associatedtype Dimension: Dimensions
}

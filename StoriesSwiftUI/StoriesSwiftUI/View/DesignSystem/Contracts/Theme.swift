//
//  Theme.swift
//  Stories
//
//
//
//

import Foundation

protocol Theme {
    associatedtype StoriesColor: StoriesColors
    associatedtype StoriesFont: StoriesFonts
    associatedtype StoriesDimension: StoriesDimensions
}

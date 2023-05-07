//
//  StoriesViewModel.swift
//  StoriesSwiftUI
//
//
//

import Foundation

protocol StoriesViewModel {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

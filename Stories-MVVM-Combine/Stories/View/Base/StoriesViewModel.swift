//
//  StoriesViewModel.swift
//  Stories
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

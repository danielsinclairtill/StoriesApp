//
//  StoriesViewModel.swift
//  StoriesSwiftUI
//
//  Created by Daniel Till on 2023-04-09.
//

import Foundation

protocol StoriesViewModel {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

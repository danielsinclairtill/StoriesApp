//
//  StoriesStateContract.swift
//  Stories
//
//
//

import Foundation

protocol StoriesStateContract: AnyObject {
    /// The current design theme of the application.
    var theme: StoriesDesignTheme { get set }
}

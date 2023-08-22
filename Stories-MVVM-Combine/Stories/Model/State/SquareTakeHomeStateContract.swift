//
//  SquareTakeHomeStateContract.swift
//  SquareTakeHome
//
//
//

import Foundation

protocol SquareTakeHomeStateContract: AnyObject {
    /// The current design theme of the application.
    var theme: SquareTakeHomeDesignTheme { get set }
}

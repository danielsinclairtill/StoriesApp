//
//  ResponseContract.swift
//  SquareTakeHome
//
//
//
//

import Foundation

public protocol ResponseContract {
    /// The decodable response of the API request.
    associatedtype Response: Decodable
}

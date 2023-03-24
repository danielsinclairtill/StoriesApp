//
//  ResponseContract.swift
//  Stories
//
//
//
//

import Foundation

public protocol ResponseContract {
    /// The decodable response of the API request.
    associatedtype Response: Decodable
}

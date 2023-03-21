//
//  RequestContract.swift
//  Stories
//
//
//
//

import Foundation

public protocol RequestContract {
    /// Path to the API endpoint, excluding the base URL.
    var path: String { get }
    /// Parameters for the request.
    var parameters: [String: Any]? { get }
    /// Time the API request should attempt to connect before timing out and returning an error.
    var timeoutInterval: TimeInterval { get }
    
}

//
//  APIError.swift
//  Stories
//
//
//
//

import Foundation

public enum APIError: Error {
    /// No interent connection found.
    case offline
    /// Internet not found or lost during a request.
    case lostConnection
    /// Error in API response.
    case serverError
    
    var message: String {
        switch self {
        case .offline:
            return "com.test.Stories.apiError.message.offlineMode".localized()
        case .lostConnection:
            return "com.test.Stories.apiError.message.noConnection".localized()
        case .serverError:
            return "com.test.Stories.apiError.message.serverError".localized()
        }
    }
}

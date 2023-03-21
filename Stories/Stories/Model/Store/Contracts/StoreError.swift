//
//  StoreError.swift
//  Stories
//
//
//
//

import Foundation

public enum StoreError {
    /// Error reading data from the store.
    case readError
    /// Error writing data to the store.
    case writeError
    
    var message: String {
        switch self {
        case .readError:
            return "com.test.Stories.storeError.message.readError".localized()
        case .writeError:
            return "com.test.Stories.storeError.message.writeError".localized()
        }
    }
}

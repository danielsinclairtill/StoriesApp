//
//  StoriesEnvironmentMock.swift
//  StoriesTests
//
//
//
//

import Foundation
@testable import Stories

class StoriesEnvironmentMock: EnvironmentContract {
    var api: APIContract { return mockApi }
    var state: StoriesStateContract { return mockState }
    
    let mockApi: StoriesAPIMock = StoriesAPIMock()
    let mockState: StoriesStateManagerMock = StoriesStateManagerMock()
    
    /// Reset and clear the mock environment state.
    func reset() {
        mockApi.reset()
    }
}

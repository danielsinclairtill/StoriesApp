//
//  SquareTakeHomeEnvironmentMock.swift
//  SquareTakeHomeTests
//
//
//
//

import Foundation
@testable import SquareTakeHome

class SquareTakeHomeEnvironmentMock: EnvironmentContract {
    var api: APIContract { return mockApi }
    var state: SquareTakeHomeStateContract { return mockState }
    
    let mockApi: SquareTakeHomeAPIMock = SquareTakeHomeAPIMock()
    let mockState: SquareTakeHomeStateManagerMock = SquareTakeHomeStateManagerMock()
    
    /// Reset and clear the mock environment state.
    func reset() {
        mockApi.reset()
    }
}

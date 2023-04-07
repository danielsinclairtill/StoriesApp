//
//  StoriesEnviromentMock.swift
//  StoriesTests
//
//
//
//

import Foundation
@testable import Stories

class StoriesEnvironmentMock: EnvironmentContract {
    var api: APIContract { return mockApi }
    var store: StoreContract { return mockStore }
    var state: ApplicationStateContract { return mockState }
    
    let mockApi: StoriesAPIMock = StoriesAPIMock()
    let mockStore: StoriesStoreMock = StoriesStoreMock()
    let mockState: ApplicationStateManagerMock = ApplicationStateManagerMock()
    
    func reset() {
        mockApi.reset()
        mockStore.reset()
    }
}

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
    var state: ApplicationStateManager { return mockState }
    
    let mockApi: StoriesAPIMock = StoriesAPIMock()
    let mockStore: StoriesStoreMock = StoriesStoreMock()
    let mockState: ApplicationStateManager = ApplicationStateManager()
    
    func reset() {
        mockApi.reset()
        mockStore.reset()
    }
}

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
    
    let mockApi: StoriesAPIMock = StoriesAPIMock()
    let mockStore: StoriesStoreMock = StoriesStoreMock()
    
    func reset() {
        mockApi.reset()
        mockStore.reset()
    }
}

//
//  StoriesStoreMock.swift
//  StoriesTests
//
//
//
//

import Foundation
@testable import Stories

class StoriesStoreMock: StoreContract {
    /// Mock list of stories stored in the application session.
    var mockStoredStories: [Story] = []
    /// Set this value to a StoreError type if you want to mock next store read request as an error.
    var mockStoreReadError: StoreError? = nil
    /// Set this value to a StoreError type if you want to mock next store write request as an error.
    var mockStoreWriteError: StoreError? = nil
    /// Number of mock store get requests called during this application session.
    var mockGetStoriesRequestsCalledCount: Int = 0
    /// Number of mock store store requests called during this application session.
    var mockStoreStoriesRequestsCalledCount: Int = 0
    
    /// Function to reset store session state.
    func reset() {
        mockStoredStories = []
        mockStoreReadError = nil
        mockStoreWriteError = nil
        mockGetStoriesRequestsCalledCount = 0
        mockStoreStoriesRequestsCalledCount = 0
    }

    func getStories(success: (([Story]) -> Void)?, failure: ((StoreError) -> Void)?) {
        mockGetStoriesRequestsCalledCount += 1
        if let error = mockStoreReadError {
            failure?(error)
        } else {
            success?(mockStoredStories)
        }
    }
    
    func storeStories(_ stories: [Story], success: ((Bool) -> Void)?, failure: ((StoreError) -> Void)?) {
        mockStoreStoriesRequestsCalledCount += 1
        if let error = mockStoreWriteError {
            failure?(error)
        } else {
            mockStoredStories = stories
            success?(true)
        }
    }
}

//
//  StoreContract.swift
//  Stories
//
//
//
//

import Foundation

public protocol StoreContract {
    /**
        Gets list of stored stories for timeline, sorted by the postion in the timeline it is placed.
        This process should be done asynchronously, and then run the success or failure block on the main thread.
     */
    func getStories(success: (([Story]) -> Void)?,
                    failure: ((StoreError) -> Void)?)

    /**
        Stores the list of stories shown in the timeline, sorted by the postion in the timeline it is placed.
        This process should be done asynchronously, and then run the success or failure block on the main thread.
     */
    func storeStories(_ stories: [Story],
                      success: ((Bool) -> Void)?,
                      failure: ((StoreError) -> Void)?)
}

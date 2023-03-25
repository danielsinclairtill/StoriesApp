//
//  StoryDetailViewControllerMock.swift
//  StoriesTests
//
//
//
//

import Foundation
@testable import Stories

class StoryDetailViewControllerMock: NSObject {
    private(set) var presentedError: String? = nil
    private(set) var setStory: Story? = nil

    func presentError(message: String) {
        presentedError = message
    }
    
    func setStory(story: Stories.Story?) {
        setStory = story
    }
}

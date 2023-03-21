//
//  ModelMockData.swift
//  StoriesTests
//
//
//
//

import Foundation
@testable import Stories

class ModelMockData {
    static func makeMockStory(id: String) -> Story {
        return Story(id: id,
                     title: nil,
                     user: nil,
                     cover: nil,
                     description: nil,
                     tags: nil)
    }

    static func makeMockStories(count: Int) -> [Story] {
        var stories: [Story] = []
        for index in 0..<count {
            stories.append(makeMockStory(id: String(index)))
        }
        return stories
    }
}

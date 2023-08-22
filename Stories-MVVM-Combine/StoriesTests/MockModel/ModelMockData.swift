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
    /// Make a count of stories objects.
    static func makeMockStories(count: Int) -> [Story] {
        var stories: [Story] = []
        for index in 0..<count {
            let story = Story(id: String(index),
                              title: "title \(index)",
                              user: User(name: "user \(index)",
                                         avatar: URL(string: "avatar_url_\(index)"),
                                         fullname: nil),
                              cover: URL(string: "cover_url_\(index)"),
                              description: "test",
                              tags: ["tag1"])

            stories.append(story)
        }
        return stories
    }
}

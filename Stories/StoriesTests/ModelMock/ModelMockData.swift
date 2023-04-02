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
    static func makeMockStory(id: String,
                              title: String? = nil,
                              user: User? = nil,
                              cover: URL? = nil,
                              description: String? = nil,
                              tags: [String]? = nil) -> Story {
        return Story(id: id,
                     title: title,
                     user: user,
                     cover: cover,
                     description: description,
                     tags: tags)
    }

    static func makeMockStories(count: Int) -> [Story] {
        var stories: [Story] = []
        for index in 0..<count {
            let story = makeMockStory(id: String(index),
                                      title: "title \(index)",
                                      user: User(name: "user \(index)",
                                                 avatar: URL(string: "avatar_url_\(index)"),
                                                 fullname: nil),
                                      cover: URL(string: "cover_url_\(index)"))
            stories.append(story)
        }
        return stories
    }
}

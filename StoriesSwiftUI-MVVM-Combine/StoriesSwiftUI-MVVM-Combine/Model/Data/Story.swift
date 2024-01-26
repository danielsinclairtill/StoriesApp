//
//  Story.swift
//  Stories
//
//
//
//

import UIKit

public struct Story: Identifiable, Decodable, Equatable, Hashable {
    var identifier: String {
        return id ?? UUID().uuidString
    }
        
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }

    public let id: String?
    public let title: String?
    public let user: User?
    public let cover: URL?
    public let description: String?
    public let tags: [String]?
    
    public init(id: String?,
                title: String?,
                user: User?,
                cover: URL?,
                description: String?,
                tags: [String]?) {
        self.id = id
        self.title = title
        self.user = user
        self.cover = cover
        self.description = description
        self.tags = tags
    }
    
    public static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.id == rhs.id
    }
}

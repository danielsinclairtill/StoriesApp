//
//  Story.swift
//  Stories
//
//
//
//

import UIKit

public struct Story: Codable, Equatable, Hashable {
    public var hashId = UUID().uuidString
    public let id: String?
    public let title: String?
    public let user: User?
    public let cover: URL?
    public let description: String?
    public let tags: [String]?
    
    var identifier: String {
        return hashId
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.hashId == rhs.hashId
    }
}

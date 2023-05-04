//
//  Story.swift
//  Stories
//
//
//
//

import UIKit

public struct Story: Codable, Equatable {
    public let id: String?
    public let title: String?
    public let user: User?
    public let cover: URL?
    public let description: String?
    public let tags: [String]?
    
    public static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.id == rhs.id
    }
}

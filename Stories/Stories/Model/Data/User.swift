//
//  User.swift
//  Stories
//
//
//
//

import Foundation

public struct User: Decodable {
    public let name: String?
    public let avatar: URL?
    public let fullname: String?
    
    public init(name: String?, avatar: URL?, fullname: String?) {
        self.name = name
        self.avatar = avatar
        self.fullname = fullname
    }
}

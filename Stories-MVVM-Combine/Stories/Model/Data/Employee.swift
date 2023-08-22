//
//  Employee.swift
//  SquareTakeHome
//
//
//

import Foundation

public enum EmployeeType: String, Codable {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try EmployeeType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

public struct Employee: Codable, Equatable, Hashable {
    /// Unique hashable id used for UICollectionViewDiffableDataSource.
    public let id = UUID().uuidString
    public let uuid: UUID
    public let fullName: String
    public let phoneNumber: String?
    public let email: String
    public let biography: String?
    public let photoUrlSmall: URL?
    public let photoUrlLarge: URL?
    public let team: String
    public let type: EmployeeType
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case email = "email_address"
        case biography
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case team
        case type = "employee_type"
    }
    
    var identifier: String {
        return id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.id == rhs.id
    }
}

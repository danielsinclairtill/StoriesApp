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
    /// Make a count of employee objects.
    static func makeMockEmployees(count: Int) -> [Employee] {
        var employees: [Employee] = []
        for _ in 0..<count {
            guard let url1 = URL(string: "testurl.com/small"),
                  let url2 = URL(string: "testurl.com/large") else { continue }
            
            let employee = Employee(uuid: UUID(),
                                    fullName: "test name",
                                    phoneNumber: "1234",
                                    email: "test@test.com",
                                    biography: "test description",
                                    photoUrlSmall: url1,
                                    photoUrlLarge: url2,
                                    team: "test team",
                                    type: .unknown)
            employees.append(employee)
        }
        return employees
    }
}

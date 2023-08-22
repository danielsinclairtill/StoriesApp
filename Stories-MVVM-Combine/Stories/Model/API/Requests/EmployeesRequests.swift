//
//  EmployeesRequests.swift
//  Stories
//
//
//
//

import Foundation

public struct EmployeesRequests {
    /**
     Retrieves the full list of employees.

     - Response:
        - employees: list of employees
     */
    public struct EmployeeList: APIRequestContract {
        public let path: String = "employees.json"
        public var parameters: [String : String]? = [:]
        public var timeoutInterval: TimeInterval = 10
        
        public struct Response: Decodable {
            public let employees: [Employee]
        }
    }
}

//
//  EnvironmentContract.swift
//  Stories
//
//
//
//

import Foundation

protocol EnvironmentContract: ObservableObject {
    var api: APIContract { get }
    var state: ApplicationStateContract { get }
}

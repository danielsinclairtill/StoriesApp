//
//  EnvironmentContract.swift
//  Stories
//
//
//
//

import Foundation

protocol EnvironmentContract {
    var api: APIContract { get }
    var store: StoreContract { get }
    var state: ApplicationStateContract { get }
}

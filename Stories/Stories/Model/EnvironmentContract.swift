//
//  EnvironmentContract.swift
//  Stories
//
//
//
//

import Foundation

public protocol EnvironmentContract {
    var api: APIContract { get }
    var store: StoreContract { get }
}

//
//  EnvironmentContract.swift
//  Stories
//
//
//

import Foundation

protocol EnvironmentContract {
    var api: APIContract { get }
    var state: StoriesStateContract { get }
}

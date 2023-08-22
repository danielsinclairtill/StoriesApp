//
//  EnvironmentContract.swift
//  SquareTakeHome
//
//
//

import Foundation

protocol EnvironmentContract {
    var api: APIContract { get }
    var state: SquareTakeHomeStateContract { get }
}

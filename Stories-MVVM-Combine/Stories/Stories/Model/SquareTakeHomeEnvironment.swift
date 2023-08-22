//
//  SquareTakeHomeEnvironment.swift
//  SquareTakeHome
//
//
//

import Foundation
import UIKit

class SquareTakeHomeEnvironment: EnvironmentContract {
    static let shared = SquareTakeHomeEnvironment()
    
    let api: APIContract = SquareTakeHomeAPI()
    let state: SquareTakeHomeStateContract = SquareTakeHomeStateManager()
}

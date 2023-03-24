//
//  StoriesEnvironment.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

class StoriesEnvironment: EnvironmentContract {
    static let shared = StoriesEnvironment()
    
    let api: APIContract = StoriesAPI()
    let store: StoreContract = StoriesStore(container: PersistenceController.shared.container)
}

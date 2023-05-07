//
//  Coordinator.swift
//  Stories
//
//
//

import Foundation
import UIKit
import RxSwift

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}

protocol TabItemCoordinator: Coordinator {
    var tabBarItemTappedWhileDisplayed: PublishSubject<Void> { get }
}

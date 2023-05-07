//
//  SettingsCoordinator.swift
//  Stories
//
//
//

import UIKit
import RxSwift

class SettingsCoordinator: TabItemCoordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    var tabBarItemTappedWhileDisplayed = PublishSubject<Void>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        settings()
    }
    
    func settings() {
        let vc = SettingsViewController(coordinator: self)
        navigationController.viewControllers = [vc]
    }
    
    func theme() {
        let vc = ThemeSettingsViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}

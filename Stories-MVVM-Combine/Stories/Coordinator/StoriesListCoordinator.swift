//
//  StoriesListCoordinator.swift
//  Stories
//
//
//

import Foundation
import UIKit
import Combine

class StoriesListCoordinator: TabItemCoordinator {
    private(set) var parentCoordinator: Coordinator?
    private(set) var children: [Coordinator] = []
    private(set) var navigationController: UINavigationController
    
    private(set) var tabBarItemTappedWhileDisplayed = PassthroughSubject<Void, Never>()
    
    init(parentCoordinator: Coordinator?,
         navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        storiesList()
    }
    
    func storiesList() {
        let vm = StoriesListViewModel(environment: StoriesEnvironment.shared,
                                       coordinator: self)
        let vc = StoriesListViewController(viewModel: vm)
        navigationController.viewControllers = [vc]
    }
}

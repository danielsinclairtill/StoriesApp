//
//  EmployeeListCoordinator.swift
//  SquareTakeHome
//
//
//

import Foundation
import UIKit
import Combine

class EmployeeListCoordinator: TabItemCoordinator {
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
        employeeList()
    }
    
    func employeeList() {
        let vm = EmployeeListViewModel(environment: SquareTakeHomeEnvironment.shared,
                                       coordinator: self)
        let vc = EmployeeListViewController(viewModel: vm)
        navigationController.viewControllers = [vc]
    }
}

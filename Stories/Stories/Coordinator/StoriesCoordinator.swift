//
//  StoriesCoordinator.swift
//  Stories
//
//
//

import UIKit
import RxSwift

class StoriesCoordinator: TabItemCoordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    var tabBarItemTappedWhileDisplayed = PublishSubject<Void>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        stories()
    }
    
    func stories() {
        let vm = TimelineCollectionViewModel(environment: StoriesEnvironment.shared,
                                             coordinator: self)
        let vc = TimelineCollectionViewController(viewModel: vm)
        navigationController.viewControllers = [vc]
    }
    
    func storyDetail(id: String) {
        let vc = StoryDetailViewController(viewModel: StoryDetailViewModel(storyId: id,
                                                                           environment: StoriesEnvironment.shared,
                                                                           coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
}

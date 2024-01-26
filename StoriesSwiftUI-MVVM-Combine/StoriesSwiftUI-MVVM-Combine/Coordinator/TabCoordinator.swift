//
//  TabCoordinator.swift
//  Stories
//
//
//

import UIKit
import Combine
//
//class TabCoordinator: Coordinator {
//    private(set) var parentCoordinator: Coordinator?
//    private(set) var children: [Coordinator] = []
//    private(set) var navigationController: UINavigationController
//    
//    private var cancelBag = Set<AnyCancellable>()
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        setupRootUITabBarController()
//    }
//    
//    // MARK: Tabs
//    private func setupRootUITabBarController() {
//        children = [storiesListTab()]
//        let rootViewController = RootUITabBarController(tabBarItems:children.map { $0.navigationController })
//        navigationController.setNavigationBarHidden(true, animated: false)
//        navigationController.viewControllers = [rootViewController]
//        
//        // pass any tab bar taps to child coordinators
//        rootViewController.tabBarIndexTappedWhileDisplayed
//            .sink(receiveValue: { [weak self] tabIndex in
//                guard let strongSelf = self,
//                      strongSelf.children.indices.contains(tabIndex) else { return }
//                let tab = strongSelf.children[tabIndex]
//                if let tab = tab as? TabItemCoordinator {
//                    tab.tabBarItemTappedWhileDisplayed.send(())
//                }
//            })
//            .store(in: &cancelBag)
//    }
//    
//    private func formatNavigationControllerUI<Controller: UINavigationController>(_ navigationController: Controller) -> Controller {
//        StoriesDesign.shared.$theme
//            .sink(receiveValue: { theme in
//                navigationController.navigationBar.barTintColor = theme.attributes.colors.primary()
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = theme.attributes.colors.primary()
//                navigationController.navigationBar.standardAppearance = appearance
//                navigationController.navigationBar.scrollEdgeAppearance = appearance
//                navigationController.navigationBar.tintColor = theme.attributes.colors.primaryFill()
//            })
//            .store(in: &cancelBag)
//        
//        return navigationController
//    }
//    
//    private func storiesListTab() -> StoriesListCoordinator {
//        let navigationController = formatNavigationControllerUI(UINavigationController())
//        navigationController.tabBarItem = UITabBarItem(title: "com.danielsinclairtill.Stories.storiesList.title".localized(),
//                                                       image: #imageLiteral(resourceName: "ListUnselected"),
//                                                       selectedImage: #imageLiteral(resourceName: "List"))
//        let coordinator = StoriesListCoordinator(parentCoordinator: self,
//                                                  navigationController: navigationController)
//        coordinator.start()
//        return coordinator
//    }
//}

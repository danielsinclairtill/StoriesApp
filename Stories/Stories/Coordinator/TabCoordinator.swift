//
//  TabCoordinator.swift
//  Stories
//
//
//

import UIKit
import RxSwift
import RxCocoa

class TabCoordinator: Coordinator {
    private let disposeBag = DisposeBag()

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setupRootUITabBarController()
    }
    
    // MARK: Tabs
    private func setupRootUITabBarController() {
        children = [storiesTab(), settingsTab()]
        let rootViewController = RootUITabBarController(tabBarItems:children.map { $0.navigationController })
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.viewControllers = [rootViewController]
        
        rootViewController.tabBarIndexTappedWhileDisplayed
            .drive(onNext: { [weak self] tabIndex in
                guard let strongSelf = self,
                        strongSelf.children.indices.contains(tabIndex) else { return }
                let tab = strongSelf.children[tabIndex]
                if let tab = tab as? TabItemCoordinator {
                    tab.tabBarItemTappedWhileDisplayed.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func formatNavigationControllerUI<Controller: UINavigationController>(_ navigationController: Controller) -> Controller {
        StoriesDesign.shared.output.theme
            .drive { theme in
                navigationController.navigationBar.barTintColor = theme.attributes.colors.primary()
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = theme.attributes.colors.primary()
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
                navigationController.navigationBar.tintColor = theme.attributes.colors.primaryFill()
            }
            .disposed(by: disposeBag)

        return navigationController
    }
    
    private func storiesTab() -> Coordinator {
        let navigationController = formatNavigationControllerUI(UINavigationController())
        navigationController.tabBarItem = UITabBarItem(title: "com.test.Stories.stories.title".localized(),
                                                       image: #imageLiteral(resourceName: "StoriesUnselected"),
                                                       selectedImage: #imageLiteral(resourceName: "Stories"))
        let coordinator = StoriesCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
        return coordinator
    }
    
    
    private func settingsTab() -> Coordinator {
        let navigationController = formatNavigationControllerUI(UINavigationController())
        navigationController.tabBarItem = UITabBarItem(title: "com.test.Stories.settings.title".localized(),
                                                       image: #imageLiteral(resourceName: "SettingsUnselected"),
                                                       selectedImage: #imageLiteral(resourceName: "Settings"))
        let coordinator = SettingsCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
        return coordinator
    }
}

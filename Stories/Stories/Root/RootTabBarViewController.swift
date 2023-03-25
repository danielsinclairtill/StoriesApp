//
//  RootTabBarViewController.swift
//  Stories
//
//
//
//

import Foundation
import UIKit
import RxSwift

class RootUITabBarController: UITabBarController, UITabBarControllerDelegate {
    private var lastSelectedIndex: Int = 0
    private let disposeBag = DisposeBag()
    
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
    
    // timeline tab
    private lazy var timelineNavigationController: StoriesNavigationController = {
        let navigationController = StoriesNavigationController(rootViewController: TimelineCollectionViewController())
        navigationController.tabBarItem = UITabBarItem(title: "com.test.Stories.stories.title".localized(),
                                                       image: #imageLiteral(resourceName: "StoriesUnselected"),
                                                       selectedImage: #imageLiteral(resourceName: "Stories"))
        return formatNavigationControllerUI(navigationController)
    }()
    
    // settings tab
    private lazy var settingsNavigationController: StoriesNavigationController = {
        let navigationController = StoriesNavigationController(rootViewController: SettingsViewController())
        navigationController.tabBarItem = UITabBarItem(title: "com.test.Stories.settings.title".localized(),
                                                       image: #imageLiteral(resourceName: "SettingsUnselected"),
                                                       selectedImage: #imageLiteral(resourceName: "Settings"))
        return formatNavigationControllerUI(navigationController)
    }()
    
    private lazy var tabBarItems: [StoriesNavigationController] = [timelineNavigationController, settingsNavigationController]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers(tabBarItems, animated: false)
        delegate = self
        
        setupDesign()
    }
    
    func setupDesign() {
        StoriesDesign.shared.output.theme
            .drive { [weak self] theme in
                guard let strongSelf = self else { return }
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = theme.attributes.colors.primary()
                strongSelf.tabBar.standardAppearance = appearance
                strongSelf.tabBar.scrollEdgeAppearance = appearance
                strongSelf.tabBar.tintColor = theme.attributes.colors.primaryFill()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        guard tabBarController.viewControllers?.indices.contains(tabBarIndex) ?? false,
            let navigationController = tabBarController.viewControllers?[tabBarIndex] as? StoriesNavigationController else { return }
        
        // if the view controller tab icon has been tapped when it was already open, perform any required logic
        if lastSelectedIndex == tabBarIndex {
            navigationController.tabBarItemTappedWhileDisplayed()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // update the lastSelectedIndex
        lastSelectedIndex = selectedIndex
    }
}

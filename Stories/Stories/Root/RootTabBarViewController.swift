//
//  RootTabBarViewController.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

class RootUITabBarController: UITabBarController, UITabBarControllerDelegate {
    private var lastSelectedIndex: Int = 0
    
    private static func formatNavigationControllerUI<Controller: UINavigationController>(_ navigationController: Controller) -> Controller {
        navigationController.navigationBar.barTintColor = StoriesDesign.shared.attributes.colors.primary()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = StoriesDesign.shared.attributes.colors.primaryFill()
        return navigationController
    }
    
    // timeline tab
    private lazy var timelineNavigationController: StoriesNavigationController = {
        let navigationController = StoriesNavigationController(rootViewController: TimelineCollectionViewController())
        navigationController.tabBarItem = UITabBarItem(title: "com.test.Stories.stories.title".localized(),
                                                       image: #imageLiteral(resourceName: "StoriesUnselected"),
                                                       selectedImage: #imageLiteral(resourceName: "Stories"))
        return Self.formatNavigationControllerUI(navigationController)
    }()
    
    // settings tab
    private lazy var settingsNavigationController: StoriesNavigationController = {
        let navigationController = StoriesNavigationController(rootViewController: SettingsViewController())
        navigationController.tabBarItem = UITabBarItem(title: "com.test.Stories.settings.title".localized(),
                                                       image: #imageLiteral(resourceName: "SettingsUnselected"),
                                                       selectedImage: #imageLiteral(resourceName: "Settings"))
        return Self.formatNavigationControllerUI(navigationController)
    }()
    
    private lazy var tabBarItems: [StoriesNavigationController] = [timelineNavigationController, settingsNavigationController]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeUpdated(notification:)),
                                               name: Notification.Name(StoriesNotifications.themeUpdated.rawValue),
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = StoriesDesign.shared.attributes.colors.primaryFill()
        setViewControllers(tabBarItems, animated: false)
        delegate = self
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
    
    // MARK: ThemeUpdated
    @objc
    func themeUpdated(notification: Notification) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = StoriesDesign.shared.attributes.colors.primaryFill()
        
        tabBarItems = tabBarItems.map { item in
            return Self.formatNavigationControllerUI(item)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(StoriesNotifications.themeUpdated.rawValue),
                                                  object: nil)
    }
}

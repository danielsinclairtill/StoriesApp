//
//  AppDelegate.swift
//  SquareTakeHome
//
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var coordinator: TabCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // set up root tab coordinator
        let navigationController = UINavigationController.init()
        let coordinator = TabCoordinator(navigationController: navigationController)
        coordinator.start()
        self.coordinator = coordinator
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

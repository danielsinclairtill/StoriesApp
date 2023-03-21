//
//  StoriesNavigationController.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

class StoriesNavigationController: UINavigationController, TabBarItemTapHandler {
    func tabBarItemTappedWhileDisplayed() {
        guard let viewController = visibleViewController as? TabBarItemTapHandler else { return }
        viewController.tabBarItemTappedWhileDisplayed()
    }
}

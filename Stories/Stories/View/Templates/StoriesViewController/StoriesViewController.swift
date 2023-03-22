//
//  StoriesViewController.swift
//  Stories
//
//
//

import Foundation
import UIKit

/// The base view controller that all view controllers in the Stories app should inherit from.
typealias StoriesViewController = ThemedViewController & ThemedViewControllerProtocol

protocol ThemedViewControllerProtocol {
    /// This function will be called when the theme of the app has been updated. The function should be responsible for updating any UI elements within the view to represent the updated theme.
    func themeUpdated(notification: Notification)
}

/// A view controller that adds a notification observer when the theme of the app updates.
class ThemedViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeUpdated(notification:)),
                                               name: Notification.Name(StoriesNotifications.themeUpdated.rawValue),
                                               object: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func themeUpdated(notification: Notification) {
        (self as? ThemedViewControllerProtocol)?.themeUpdated(notification: notification)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(StoriesNotifications.themeUpdated.rawValue),
                                                  object: nil)
    }
}

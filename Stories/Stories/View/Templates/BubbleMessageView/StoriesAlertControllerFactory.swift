//
//  StoriesAlertController.swift
//  Stories
//
//
//
//

import UIKit

class StoriesAlertControllerFactory {
    /// Alert shown when the application is started when it is offline.
    static func createOfflineAlert(message: String,
                                   closeHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "com.test.Stories.alert.title".localized(),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "com.test.Stories.alert.offline.action.goOffline".localized(),
                                      style: .default,
                                      handler: closeHandler))
        alert.view.tintColor = StoriesDesign.shared.theme.attributes.colors.primaryFill()
        return alert
    }
    
    /// Alert shown when the application attempts a request, but recieves an API error.
    static func createAPIError(message: String,
                               offlineHandler: ((UIAlertAction) -> Void)?,
                               refreshHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "com.test.Stories.alert.title".localized(),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "com.test.Stories.alert.offline.action.goOffline".localized(),
                                      style: .default,
                                      handler: offlineHandler))
        alert.addAction(UIAlertAction(title: "com.test.Stories.alert.apiError.action.refresh".localized(),
                                      style: .default,
                                      handler: refreshHandler))
        alert.view.tintColor = StoriesDesign.shared.theme.attributes.colors.primaryFill()
        return alert
    }
    
    /// Alert shown when the application attempts a request, but recieves an API error.
    static func createAPIError(message: String,
                               completionHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "com.test.Stories.alert.title".localized(),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "com.test.Stories.alert.apiError.action.okay".localized(),
                                      style: .default,
                                      handler: completionHandler))
        alert.view.tintColor = StoriesDesign.shared.theme.attributes.colors.primaryFill()
        return alert
    }
}

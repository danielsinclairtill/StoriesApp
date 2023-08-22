//
//  AlertFactory.swift
//  Stories
//
//
//

import Foundation
import UIKit

class AlertFactory {
    /// Alert shown when the application is offline or attempts a request, but recieves an API error.
    static func createAPIError(message: String,
                               refreshHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "com.danielsinclairtill.Stories.alert.title".localized(),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "com.danielsinclairtill.Stories.alert.apiError.action.okay".localized(),
                                      style: .default,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "com.danielsinclairtill.Stories.alert.apiError.action.refresh".localized(),
                                      style: .default,
                                      handler: refreshHandler))
        alert.view.tintColor = StoriesDesign.shared.theme.attributes.colors.primaryFill()
        return alert
    }
}

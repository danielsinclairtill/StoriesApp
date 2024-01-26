//
//  String+Localized.swift
//  Stories
//
//
//
//

import Foundation

extension String {
    func localized(withComment: String = "") -> String {
        let localizedString = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, comment: self)
        guard localizedString != self else {
            fatalError(String(format: "Cannot find value for localized string: %@", self))
        }
        return localizedString
    }
}

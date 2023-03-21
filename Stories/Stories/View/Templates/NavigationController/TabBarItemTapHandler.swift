//
//  TabBarItemTapHandler.swift
//  Stories
//
//
//
//

import Foundation

protocol TabBarItemTapHandler {
    /// Handler function for when a viewcontrollers corresponding tab bar item is tapped while the view controller is already displayed.
    func tabBarItemTappedWhileDisplayed()
}

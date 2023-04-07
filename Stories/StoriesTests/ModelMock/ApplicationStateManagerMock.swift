//
//  ApplicationStateManagerMock.swift
//  StoriesTests
//
//
//

import Foundation
@testable import Stories

class ApplicationStateManagerMock: ApplicationStateContract {
    var hasSeenOfflineModeMessage: Bool = false
    var theme: Stories.StoriesDesignTheme = .plain
}

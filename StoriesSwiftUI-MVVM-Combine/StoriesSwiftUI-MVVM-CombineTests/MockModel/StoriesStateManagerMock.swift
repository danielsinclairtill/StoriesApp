//
//  StoriesStateManagerMock.swift
//  StoriesTests
//
//
//

import Foundation
@testable import StoriesSwiftUI_MVVM_Combine

class StoriesStateManagerMock: ApplicationStateContract {
    var hasSeenOfflineModeMessage: Bool = false
    var theme: StoriesDesignTheme = .plain
}

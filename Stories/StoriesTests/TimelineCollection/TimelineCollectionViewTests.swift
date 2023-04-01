//
//  TimelineCollectionViewTests.swift
//  StoriesTests
//
//
//

import XCTest
@testable import Stories
import SnapshotTesting

class TimelineCollectionViewTests: XCTestCase {
    let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()

    override func setUp() {
        super.setUp()
        mockEnvironment.reset()
    }
}

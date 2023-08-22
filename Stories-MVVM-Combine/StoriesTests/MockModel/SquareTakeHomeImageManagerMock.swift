//
//  SquareTakeHomeImageManagerMock.swift
//  SquareTakeHomeTests
//
//
//
//

import Foundation
@testable import SquareTakeHome
import UIKit

class SquareTakeHomeImageManagerMock: ImageManagerContract {
    /// List of mock prefetch taks called during this API session in order.
    var mockPrefetchTaskURLs: [URL] = []
    
    func reset() {
        mockPrefetchTaskURLs = []
    }
    
    func prefetchImages(_ urls: [URL], reset: Bool) {
        if reset {
            mockPrefetchTaskURLs = []
        }
        mockPrefetchTaskURLs += urls
    }

    func setImageView(imageView: UIImageView, url: URL?) {
        return
    }
}

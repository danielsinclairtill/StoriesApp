//
//  StoriesImageManagerMock.swift
//  StoriesTests
//
//
//
//

import Foundation
@testable import StoriesSwiftUI_MVVM_Combine
import UIKit

class StoriesImageManagerMock: ImageManagerContract {
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

    func setImageView(imageView: UIImageView, placeholder: UIView, url: URL?) {
        return
    }
}

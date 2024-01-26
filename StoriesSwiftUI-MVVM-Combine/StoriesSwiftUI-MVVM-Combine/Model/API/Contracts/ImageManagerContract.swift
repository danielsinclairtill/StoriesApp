//
//  ImageManagerContract.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

public protocol ImageManagerContract {
    /**
     Prefetches a list of images given by URL.
     - Parameters:
        - urls: List of images given by URLs.
        - reset: Boolean value determining to reset and cancel all currently running prefetch jobs.
     */
    func prefetchImages(_ urls: [URL], reset: Bool)

    /**
     Set an image view with an image from a specified URL. This image could be downloaded or fetched from the cache.
     While the url image is loading a placeholder image is displayed.
     This process is done asynchronously.
     - Parameters:
        - imageView: The UIImageView to set.
        - placeholder: The UIImageView to use as a placeholder while the image is being set.
        - url: The URL of the image to be set to the imageView.
     */
    func setImageView(imageView: UIImageView, placeholder: UIView, url: URL?)
}

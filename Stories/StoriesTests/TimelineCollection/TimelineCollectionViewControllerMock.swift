//
//  TimelineCollectionViewControllerMock.swift
//  StoriesTests
//
//
//
//

import Foundation
@testable import Stories

class TimelineCollectionViewControllerMock: NSObject, TimelineCollectionViewControllerContract {
    private(set) var navigatedToStory: Story? = nil
    private(set) var initiatedLoadingTimeline = false
    private(set) var reloadedTimeline = false
    private(set) var loadedNextPage = false
    private(set) var presentedOfflineAlert: String? = nil
    private(set) var presentedError: String? = nil
    private(set) var presentedBubbleMessage: String? = nil
    private(set) var animatedScrollToTop = false


    func navigateToStory(_ story: Story) {
        navigatedToStory = story
    }
    
    func initiateLoadingTimeline() {
        initiatedLoadingTimeline = true
    }
    
    func reloadTimeline() {
        reloadedTimeline = true
        loadedNextPage = false
    }
    
    func loadNextPage() {
        loadedNextPage = true
    }
    
    func presentOfflineAlert(message: String) {
        presentedOfflineAlert = message
    }
    
    func presentError(message: String) {
        presentedError = message
    }
    
    func presentBubbleMessage(message: String) {
        presentedBubbleMessage = message
    }
    
    func animateScrollToTop(animated: Bool) {
        animatedScrollToTop = true
    }
}

//
//  TimelineCollection.swift
//  StoriesTests
//
//
//
//

import XCTest
@testable import Stories

class TimelineCollectionTests: XCTestCase {
    let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()

    override func setUp() {
        mockEnvironment.reset()
    }
    
    // MARK: Online
//    func testRefreshStoriesOnViewDidLoad() {
//        let mockStories: [Story] =  ModelMockData.makeMockStories(count: 10)
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
//        ]
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.viewDidLoad()
//        
//        XCTAssertTrue(mockView.initiatedLoadingTimeline)
//        XCTAssertTrue(mockView.reloadedTimeline)
//
//        let expectedRequest = StoriesRequests.StoriesTimelinePage()
//        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
//        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
//        XCTAssertEqual(viewModel.stories, mockStories)
//    }
//    
//    func testRefreshStoriesImagesArePrefetched() {
//        let mockStories: [Story] =  ModelMockData.makeMockStories(count: 10)
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
//        ]
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.viewDidLoad()
//        
//        var prefetchImageURLs: [URL] = []
//        for mockStory in mockStories {
//            if let cover = mockStory.cover {
//                prefetchImageURLs.append(cover)
//            }
//            if let avatar = mockStory.user?.avatar {
//                prefetchImageURLs.append(avatar)
//            }
//        }
//        XCTAssertEqual(mockEnvironment.mockApi.mockImageManager.mockPrefetchTaskURLs, prefetchImageURLs)
//    }
//    
//    func testDoNotRefreshDataAndShowAlertOnViewDidLoadOffline() {
//        mockEnvironment.mockApi.mockIsConnectedToInternet = false
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .failure(.offline)
//        ]
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        viewModel.viewControllerDelegate = mockView
//        
//        viewModel.viewDidLoad()
//        
//        XCTAssertEqual(mockView.presentedOfflineAlert, APIError.offline.message)
//
//        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 0)
//        XCTAssertTrue(viewModel.stories.isEmpty)
//    }
//    
//    func testRefreshStoriesPresentsError() {
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .failure(.serverError)
//        ]
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.refresh()
//        
//        XCTAssertTrue(mockView.initiatedLoadingTimeline)
//        XCTAssertFalse(mockView.reloadedTimeline)
//        XCTAssertEqual(mockView.presentedError, APIError.serverError.message)
//        XCTAssertTrue(viewModel.stories.isEmpty)
//    }
//    
//    func testRefreshStoriesPresentsErrorIfEmpty() {
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .success(StoriesRequests.StoriesTimelinePage.Response(stories: [], nextUrl: URL(string: "test")!))
//        ]
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.refresh()
//        
//        XCTAssertTrue(mockView.initiatedLoadingTimeline)
//        XCTAssertFalse(mockView.reloadedTimeline)
//        XCTAssertEqual(mockView.presentedError, APIError.serverError.message)
//        XCTAssertTrue(viewModel.stories.isEmpty)
//    }
//    
//    func testLoadNextPageLoadsMoreStoriesInTimeline() {
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
//        ]
//        
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.stories = ModelMockData.makeMockStories(count: 10)
//        
//        viewModel.viewControllerDelegate = mockView
//        
//        viewModel.loadNextPage()
//        
//        XCTAssertTrue(mockView.loadedNextPage)
//        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
//        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.parameters?["offset"] as? Int == 11 })
//        XCTAssertEqual(viewModel.stories.count, 20)
//    }
//    
//    // MARK: Offline
//    func testStoreStoriesOnRefreshStories() {
//        let mockStories: [Story] =  ModelMockData.makeMockStories(count: 10)
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
//        ]
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.refresh()
//
//        XCTAssertEqual(mockEnvironment.mockStore.mockStoreStoriesRequestsCalledCount, 1)
//        XCTAssertEqual(mockEnvironment.mockStore.mockStoredStories, mockStories)
//    }
//    
//    func testStoreStoriesFirstTimeShowsBubbleMessage() {
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
//        ]
//        ApplicationManager.shared.hasSeenOfflineModeMessage = false
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.refresh()
//        
//        XCTAssertEqual(
//            mockView.presentedBubbleMessage,
//            "com.test.Stories.stories.bubbleMessage.offlineAvailable".localized()
//        )
//    }
//    
//    func testStoreStoriesSecondTimeShowsNoBubbleMessage() {
//        mockEnvironment.mockApi.mockAPIResponses = [
//            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
//        ]
//        ApplicationManager.shared.hasSeenOfflineModeMessage = true
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.viewDidLoad()
//        
//        XCTAssertNil(mockView.presentedBubbleMessage)
//    }
//    
//    func testGetStoredStoriesOffline() {
//        let mockStories = ModelMockData.makeMockStories(count: 10)
//        mockEnvironment.mockStore.mockStoredStories = mockStories
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.refreshOffline()
//        
//        XCTAssertTrue(mockView.initiatedLoadingTimeline)
//        XCTAssertTrue(mockView.reloadedTimeline)
//
//        XCTAssertEqual(mockEnvironment.mockStore.mockGetStoriesRequestsCalledCount, 1)
//        XCTAssertEqual(viewModel.stories, mockStories)
//    }
//    
//    func testGetStoredStoriesPresentsError() {
//        let mockStories: [Story] = ModelMockData.makeMockStories(count: 10)
//        mockEnvironment.mockStore.mockStoredStories = mockStories
//        mockEnvironment.mockStore.mockStoreReadError = StoreError.readError
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.refreshOffline()
//        
//        XCTAssertTrue(mockView.initiatedLoadingTimeline)
//        XCTAssertFalse(mockView.reloadedTimeline)
//        XCTAssertEqual(
//            mockView.presentedError,
//            StoreError.readError.message
//        )
//
//        XCTAssertEqual(mockEnvironment.mockStore.mockGetStoriesRequestsCalledCount, 1)
//        XCTAssertTrue(viewModel.stories.isEmpty)
//    }
//    
//    func testGetStoredStoriesPresentsErrorIfEmpty() {
//        mockEnvironment.mockStore.mockStoredStories = []
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//
//        XCTAssertTrue(viewModel.stories.isEmpty)
//        
//        viewModel.refreshOffline()
//        
//        XCTAssertTrue(mockView.initiatedLoadingTimeline)
//        XCTAssertFalse(mockView.reloadedTimeline)
//        XCTAssertEqual(
//            mockView.presentedError,
//            StoreError.readError.message
//        )
//
//        XCTAssertEqual(mockEnvironment.mockStore.mockGetStoriesRequestsCalledCount, 1)
//        XCTAssertTrue(viewModel.stories.isEmpty)
//    }
//    
//    // MARK: TabBarItem
//    func testTapTabBarItemScrollsToTop() {
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//        
//        viewModel.tabBarItemTappedWhileDisplayed(isAtTopOfView: false)
//        
//        XCTAssertTrue(mockView.animatedScrollToTop)
//    }
//    
//    func testTapTabBarItemDoesNotScrollsToTopWhileScrolling() {
//        let mockView = TimelineCollectionViewControllerMock()
//        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
//        viewModel.viewControllerDelegate = mockView
//        viewModel.isScrolling = true
//    
//        viewModel.tabBarItemTappedWhileDisplayed(isAtTopOfView: false)
//        
//        XCTAssertFalse(mockView.animatedScrollToTop)
//    }
}

//
//  TimelineCollectionViewModelTests.swift
//  StoriesTests
//
//
//
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Stories

class TimelineCollectionViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()

    override func setUp() {
        super.setUp()
        mockEnvironment.reset()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    // MARK: Online
    func testRefreshStoriesOnViewDidLoad() {
        let mockStories: [Story] =  ModelMockData.makeMockStories(count: 10)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: mockStories, nextUrl: URL(string: "test")!))
        ]
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)

        XCTAssertTrue(stories.events.isEmpty)
        
        viewModel.input.viewDidLoad.onNext(())

        let expectedRequest = StoriesRequests.StoriesTimelinePage()
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(stories.events.first?.value.element, mockStories)
    }
    
    func testRefreshStoriesImagesArePrefetched() {
        let mockStories: [Story] =  ModelMockData.makeMockStories(count: 10)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: mockStories, nextUrl: URL(string: "test")!))
        ]
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)

        viewModel.input.viewDidLoad.onNext(())
        
        var prefetchImageURLs: [URL] = []
        for mockStory in mockStories {
            if let cover = mockStory.cover {
                prefetchImageURLs.append(cover)
            }
            if let avatar = mockStory.user?.avatar {
                prefetchImageURLs.append(avatar)
            }
        }
        XCTAssertEqual(mockEnvironment.mockApi.mockImageManager.mockPrefetchTaskURLs, prefetchImageURLs)
    }
    
    func testDoNotRefreshDataAndShowAlertOnViewDidLoadOffline() {
        mockEnvironment.mockApi.mockIsConnectedToInternet = false
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.offline)
        ]
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)
        let errorMessage = scheduler.createObserver(String.self)
        viewModel.output.error.drive(errorMessage).disposed(by: disposeBag)
        
        XCTAssertTrue(stories.events.isEmpty)

        viewModel.input.viewDidLoad.onNext(())
        
        XCTAssertEqual(errorMessage.events.first?.value.element, APIError.offline.message)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 0)
        XCTAssertTrue(stories.events.isEmpty)
    }
    
    func testRefreshStoriesPresentsError() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.serverError)
        ]
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)
        let errorMessage = scheduler.createObserver(String.self)
        viewModel.output.error.drive(errorMessage).disposed(by: disposeBag)
        
        XCTAssertTrue(stories.events.isEmpty)
        
        viewModel.input.refresh.onNext(())
        
        XCTAssertEqual(errorMessage.events.first?.value.element, APIError.serverError.message)
        XCTAssertTrue(stories.events.isEmpty)
    }
    
    func testRefreshStoriesPresentsErrorIfEmpty() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: [], nextUrl: URL(string: "test")!))
        ]
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)
        let errorMessage = scheduler.createObserver(String.self)
        viewModel.output.error.drive(errorMessage).disposed(by: disposeBag)
        
        XCTAssertTrue(stories.events.isEmpty)

        viewModel.input.refresh.onNext(())
        
        XCTAssertEqual(errorMessage.events.first?.value.element, APIError.serverError.message)
        XCTAssertTrue(stories.events.isEmpty)
    }
    
    func testLoadNextPageLoadsMoreStoriesInTimeline() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!)),
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
        ]
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)
        viewModel.input.viewDidLoad.onNext(())
                
        viewModel.input.loadNextPage.onNext(())

        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 2)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { Int($0.parameters?["offset"] ?? "") == 11 })
        XCTAssertEqual(stories.events.last?.value.element?.count, 20)
    }
    
    // MARK: Offline
    func testStoreStoriesOnRefreshStories() {
        let mockStories: [Story] =  ModelMockData.makeMockStories(count: 10)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: mockStories, nextUrl: URL(string: "test")!))
        ]
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)

        XCTAssertTrue(stories.events.isEmpty)

        viewModel.input.refresh.onNext(())

        XCTAssertEqual(mockEnvironment.mockStore.mockStoreStoriesRequestsCalledCount, 1)
        XCTAssertEqual(mockEnvironment.mockStore.mockStoredStories, mockStories)
    }
    
    func testStoreStoriesFirstTimeShowsBubbleMessage() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
        ]
        ApplicationManager.shared.hasSeenOfflineModeMessage = false
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let bubbleMessage = scheduler.createObserver(String.self)
        viewModel.output.bubbleMessage.drive(bubbleMessage).disposed(by: disposeBag)
        
        viewModel.input.viewDidLoad.onNext(())

        XCTAssertEqual(bubbleMessage.events.last?.value.element, "com.test.Stories.stories.bubbleMessage.offlineAvailable".localized())
    }
    
    func testStoreStoriesSecondTimeShowsNoBubbleMessage() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: ModelMockData.makeMockStories(count: 10), nextUrl: URL(string: "test")!))
        ]
        ApplicationManager.shared.hasSeenOfflineModeMessage = true
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let bubbleMessage = scheduler.createObserver(String.self)
        viewModel.output.bubbleMessage.drive(bubbleMessage).disposed(by: disposeBag)
        
        viewModel.input.viewDidLoad.onNext(())

        XCTAssertTrue(bubbleMessage.events.isEmpty)
    }
    
    func testGetStoredStoriesOffline() {
        let mockStories = ModelMockData.makeMockStories(count: 10)
        mockEnvironment.mockStore.mockStoredStories = mockStories
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)

        XCTAssertTrue(stories.events.isEmpty)

        viewModel.input.refreshOffline.onNext(())

        XCTAssertEqual(mockEnvironment.mockStore.mockGetStoriesRequestsCalledCount, 1)
        XCTAssertEqual(mockEnvironment.mockStore.mockStoredStories, mockStories)
    }
    
    func testGetStoredStoriesPresentsError() {
        let mockStories: [Story] = ModelMockData.makeMockStories(count: 10)
        mockEnvironment.mockStore.mockStoredStories = mockStories
        mockEnvironment.mockStore.mockStoreReadError = StoreError.readError
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)
        let errorMessage = scheduler.createObserver(String.self)
        viewModel.output.error.drive(errorMessage).disposed(by: disposeBag)
        
        XCTAssertTrue(stories.events.isEmpty)

        viewModel.input.refreshOffline.onNext(())

        XCTAssertEqual(errorMessage.events.first?.value.element, StoreError.readError.message)

        XCTAssertEqual(mockEnvironment.mockStore.mockGetStoriesRequestsCalledCount, 1)
        XCTAssertTrue(stories.events.isEmpty)
    }
    
    func testGetStoredStoriesPresentsErrorIfEmpty() {
        mockEnvironment.mockStore.mockStoredStories = []
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let stories = scheduler.createObserver(Array<Story>.self)
        viewModel.output.stories.drive(stories).disposed(by: disposeBag)
        let errorMessage = scheduler.createObserver(String.self)
        viewModel.output.error.drive(errorMessage).disposed(by: disposeBag)
        
        XCTAssertTrue(stories.events.isEmpty)

        viewModel.input.refreshOffline.onNext(())

        XCTAssertEqual(errorMessage.events.first?.value.element, StoreError.readError.message)

        XCTAssertEqual(mockEnvironment.mockStore.mockGetStoriesRequestsCalledCount, 1)
        XCTAssertTrue(stories.events.isEmpty)
    }
    
    // MARK: TabBarItem
    func testTapTabBarItemDoesNotScrollsToTopWhileScrolling() {
        let viewModel = TimelineCollectionViewModel(environment: mockEnvironment)
        let scrollToTop = scheduler.createObserver(Void.self)
        viewModel.output.scrollToTop.drive(scrollToTop).disposed(by: disposeBag)
    
        viewModel.input.isScrolling.onNext(true)
        viewModel.input.tabBarItemTapped.onNext(())
        
        XCTAssertTrue(scrollToTop.events.isEmpty)
    }
}

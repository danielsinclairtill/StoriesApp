//
//  StoriesListViewModelTests.swift
//  Stories
//
//
//
//

import XCTest
import Combine
@testable import StoriesSwiftUI_MVVM_Combine

class StoriesListViewModelTests: XCTestCase {
    private let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()
    private let mockCoordinator = StoriesListCoordinator(parentCoordinator: nil,
                                                         navigationController: UINavigationController())
    private var cancelBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockEnvironment.reset()
        cancelBag = Set<AnyCancellable>()
    }
    
    // MARK: Online
    func testRefreshStories() {
        let mockStories: [Story] = ModelMockData.makeMockStories(count: 10)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: mockStories, nextUrl: URL(string: "test")!))
        ]
        let viewModel = StoriesListViewModel(environment: mockEnvironment)
        
        XCTAssertTrue(viewModel.output.stories.isEmpty)
        
        viewModel.input.refreshBegin.send(())
        
        XCTAssertTrue(viewModel.output.isLoading)
        
        viewModel.input.refresh.send(())
        
        let expectedRequest = StoriesRequests.StoriesTimelinePage()
        XCTAssertFalse(viewModel.output.isLoading)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(viewModel.output.stories, mockStories)
    }
    
    func testRefreshStoriesServerError() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.serverError)
        ]
        let viewModel = StoriesListViewModel(environment: mockEnvironment)
        
        XCTAssertTrue(viewModel.output.stories.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertEqual(viewModel.output.error, APIError.serverError.message)
    }
    
    func testRefreshStoriesEmptyError() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: [], nextUrl: URL(string: "test")!))
        ]
        let viewModel = StoriesListViewModel(environment: mockEnvironment)
        
        XCTAssertTrue(viewModel.output.stories.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertEqual(viewModel.output.error, APIError.serverError.message)
    }
    
    func testRefreshStoriesLostConnectionError() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.lostConnection)
        ]
        let viewModel = StoriesListViewModel(environment: mockEnvironment)
        
        XCTAssertTrue(viewModel.output.stories.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertEqual(viewModel.output.error, APIError.lostConnection.message)
    }
    
    func testRefreshStoriesOfflineError() {
        mockEnvironment.mockApi.mockIsConnectedToInternet = false
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.lostConnection)
        ]
        let viewModel = StoriesListViewModel(environment: mockEnvironment)
        
        XCTAssertTrue(viewModel.output.stories.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 0)
        XCTAssertEqual(viewModel.output.error, APIError.offline.message)
    }
    
    func testViewDidLoadShowsErrorIfOffline() {
        mockEnvironment.mockApi.mockIsConnectedToInternet = false
        let viewModel = StoriesListViewModel(environment: mockEnvironment)
        
        XCTAssertTrue(viewModel.output.stories.isEmpty)
        
        viewModel.input.viewDidLoad.send(())
        
        XCTAssertEqual(viewModel.output.error, APIError.offline.message)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 0)
    }
    
    func testRefreshStoriesImagesArePrefetched() {
        let mockStories: [Story] = ModelMockData.makeMockStories(count: 20)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(StoriesRequests.StoriesTimelinePage.Response(stories: mockStories, nextUrl: URL(string: "test")!))
        ]
        let viewModel = StoriesListViewModel(environment: mockEnvironment)
        
        XCTAssertTrue(mockEnvironment.mockApi.mockImageManager.mockPrefetchTaskURLs.isEmpty)
        
        viewModel.input.refresh.send(())
        
        // prefetches only the first 10 images
        let prefetchImageURLs: [URL] = Array(mockStories.prefix(upTo: 10)).compactMap { $0.cover }
        XCTAssertEqual(mockEnvironment.mockApi.mockImageManager.mockPrefetchTaskURLs, prefetchImageURLs)
    }
}

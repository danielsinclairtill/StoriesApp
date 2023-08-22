//
//  StoryDetailViewModelTests.swift
//  StoriesTests
//
//  Created by Daniel Till on 2023-08-22.
//

import Foundation
import XCTest
import Combine
@testable import Stories

class StoryDetailViewModelTests: XCTestCase {
    private let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()
    private let mockCoordinator = StoriesListCoordinator(parentCoordinator: nil,
                                                         navigationController: UINavigationController())
    private var cancelBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockEnvironment.reset()
        cancelBag = Set<AnyCancellable>()
    }
    
    func testStoryDetailLoad() {
        let storyId = "123"
        let story = Story(id: storyId,
                          title: "test story",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "test description",
                          tags: nil)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(story)
        ]
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment,
                                             coordinator: mockCoordinator)
        
        viewModel.input.viewDidLoad.send(())
        
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(viewModel.output.story, story)
    }
    
    func testStoryDetailPresentsError() {
        let storyId = "123"
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(APIError.serverError)
        ]
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment,
                                             coordinator: mockCoordinator)
        
        viewModel.input.viewDidLoad.send(())

        XCTAssertEqual(viewModel.output.error, APIError.serverError.message)
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(viewModel.output.story, nil)
    }
}

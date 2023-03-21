//
//  StoryDetailTests.swift
//  StoriesTests
//
//
//
//

import XCTest
@testable import Stories

class StoryDetailTests: XCTestCase {
    let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()

    override func setUp() {
        mockEnvironment.reset()
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
        let mockView = StoryDetailViewControllerMock()
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment)
        viewModel.viewControllerDelegate = mockView

        XCTAssertNil(viewModel.story)
        
        viewModel.loadStory()
        
        XCTAssertEqual(mockView.setStory, story)

        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(viewModel.story, story)
    }
    
    func testStoryDetailPresentsError() {
        let storyId = "123"
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(APIError.serverError)
        ]
        let mockView = StoryDetailViewControllerMock()
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment)
        viewModel.viewControllerDelegate = mockView

        XCTAssertNil(viewModel.story)
        
        viewModel.loadStory()
        
        XCTAssertEqual(mockView.setStory, nil)
        XCTAssertEqual(
            mockView.presentedError,
            APIError.serverError.message
        )
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(viewModel.story, nil)
    }
}

//
//  StoryDetailViewModelTests.swift
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

class StoryDetailViewModelTests: XCTestCase {
    let disposeBag: DisposeBag = DisposeBag()
    let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()

    override func setUp() {
        super.setUp()
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
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment)
        viewModel.output.story.drive().disposed(by: disposeBag)
        
        viewModel.input.viewDidLoad.onNext(())
        
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(try viewModel.output.story.toBlocking().first(), story)
    }
    
    func testStoryDetailPresentsError() {
        let storyId = "123"
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(APIError.serverError)
        ]
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment)
        viewModel.output.story.drive().disposed(by: disposeBag)
        viewModel.output.error.drive().disposed(by: disposeBag)

        viewModel.input.viewDidLoad.onNext(())

        XCTAssertEqual(
            try viewModel.output.error.toBlocking().first(),
            APIError.serverError.message
        )
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(try viewModel.output.story.toBlocking().first() ?? nil, nil)
    }
}

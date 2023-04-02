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
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()

    override func setUp() {
        super.setUp()
        mockEnvironment.reset()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
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
        let actualStory = scheduler.createObserver(Story?.self)
        viewModel.output.story.drive(actualStory).disposed(by: disposeBag)
        
        viewModel.input.viewDidLoad.onNext(())
        
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(actualStory.events.last?.value.element, story)
    }
    
    func testStoryDetailPresentsError() {
        let storyId = "123"
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(APIError.serverError)
        ]
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment)
        let actualStory = scheduler.createObserver(Story?.self)
        viewModel.output.story.drive(actualStory).disposed(by: disposeBag)
        let errorMessage = scheduler.createObserver(String.self)
        viewModel.output.error.drive(errorMessage).disposed(by: disposeBag)
        
        viewModel.input.viewDidLoad.onNext(())

        XCTAssertEqual(
            errorMessage.events.last?.value.element,
            APIError.serverError.message
        )
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(actualStory.events.last?.value.element ?? nil, nil)
    }
}

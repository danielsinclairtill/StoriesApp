//
//  StoryDetailTests.swift
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

class StoryDetailTests: XCTestCase {
    let mockEnvironment: StoriesEnvironmentMock = StoriesEnvironmentMock()
    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        mockEnvironment.reset()
    }

    override func tearDown() {
        testScheduler = nil
        disposeBag = nil
        super.tearDown()
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
        let storyRecorded = testScheduler.createObserver(Story?.self)
        viewModel.output.story
            .drive(storyRecorded)
            .disposed(by: disposeBag)

        XCTAssertNil(storyRecorded.events.last?.value.element ?? nil)
        
        viewModel.input.viewDidLoad.onNext(())
        
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(storyRecorded.events.last?.value.element, story)
    }
    
    func testStoryDetailPresentsError() {
        let storyId = "123"
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(APIError.serverError)
        ]
        let viewModel = StoryDetailViewModel(storyId: storyId,
                                             environment: mockEnvironment)
        let storyRecorded = testScheduler.createObserver(Story?.self)
        viewModel.output.story
            .drive(storyRecorded)
            .disposed(by: disposeBag)
        let errorRecorded = testScheduler.createObserver(String.self)
        viewModel.output.error
            .drive(errorRecorded)
            .disposed(by: disposeBag)
        
        XCTAssertNil(storyRecorded.events.last?.value.element ?? nil)

        viewModel.input.viewDidLoad.onNext(())

        XCTAssertEqual(
            errorRecorded.events.last?.value.element,
            APIError.serverError.message
        )
        let expectedRequest = StoriesRequests.StoryDetail(id: storyId)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(storyRecorded.events.last?.value.element ?? nil, nil)
    }
}

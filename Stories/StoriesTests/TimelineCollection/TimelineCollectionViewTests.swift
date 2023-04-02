//
//  TimelineCollectionViewTests.swift
//  StoriesTests
//
//
//

import XCTest
@testable import Stories
import SnapshotTesting
import RxSwift
import RxCocoa

class TimelineCollectionViewTests: XCTestCase {
    func testTimelineCollection() {
        let stories = ModelMockData.makeMockStories(count: 20)
        let viewModel = MockTimelineCollectionView(stories: stories)
        let view = TimelineCollectionViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
}

private class MockTimelineCollectionView: TimelineCollectionViewModelContract {
    var input: TimelineCollectionViewModelInput { return inputBind }
    private let inputBind = TimelineCollectionViewModelInputBind()
    var output: TimelineCollectionViewModelOutput { return outputBind }
    private let outputBind: TimelineCollectionViewModelOutputBind
    
    init(stories: [Story],
         isLoading: BehaviorSubject<Bool>? = nil,
         error: PublishSubject<String>? = nil,
         bubbleMessage: PublishSubject<String>? = nil) {
        self.outputBind = TimelineCollectionViewModelOutputBind(storiesBind: BehaviorSubject(value: stories),
                                                                isLoadingBind: (isLoading ?? BehaviorSubject(value: false)),
                                                                errorBind: (error ?? PublishSubject()),
                                                                bubbleMessageBind: (bubbleMessage ?? PublishSubject()))
    }
    
    let imageManager: ImageManagerContract = StoriesImageManagerMock()
}

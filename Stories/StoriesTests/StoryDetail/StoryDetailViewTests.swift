//
//  StoryDetailViewTests.swift
//  StoriesTests
//
//
//

import XCTest
@testable import Stories
import SnapshotTesting
import RxSwift
import RxCocoa

class StoryDetailViewTests: XCTestCase {
    func testStoryDetail() {
        let story = Story(id: "id",
                          title: "test story",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "test description",
                          tags: ["tag1", "tag2", "tag3"])
        let viewModel = MockStoryDetailViewModel(story: story,
                                                 error: nil)
        let view = StoryDetailViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
    
    func testStoryDetailLongTitle() {
        let story = Story(id: "id",
                          title: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "test description",
                          tags: ["tag1", "tag2", "tag3"])
        let viewModel = MockStoryDetailViewModel(story: story,
                                                 error: nil)
        let view = StoryDetailViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
    
    func testStoryDetailLongUsername() {
        let story = Story(id: "id",
                          title: "test story",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "test description",
                          tags: ["tag1", "tag2", "tag3"])
        let viewModel = MockStoryDetailViewModel(story: story,
                                                 error: nil)
        let view = StoryDetailViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
    
    func testStoryDetailLongDetail() {
        let story = Story(id: "id",
                          title: "test story",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                          tags: ["tag1", "tag2", "tag3"])
        let viewModel = MockStoryDetailViewModel(story: story,
                                                 error: nil)
        let view = StoryDetailViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
    
    func testStoryDetailMax5TagsShown() {
        let story = Story(id: "id",
                          title: "test story",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "test description",
                          tags: ["tag1", "tag2", "tag3", "tag4", "tag5", "tag6"])
        let viewModel = MockStoryDetailViewModel(story: story,
                                                 error: nil)
        let view = StoryDetailViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
    
    func testStoryDetailSmallDevice() {
        let story = Story(id: "id",
                          title: "test story",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "test description",
                          tags: ["tag1", "tag2", "tag3"])
        let viewModel = MockStoryDetailViewModel(story: story,
                                                 error: nil)
        let view = StoryDetailViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(on: .iPhoneSe,
                                  traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(on: .iPhoneSe,
                                  traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
    
    func testStoryDetailIPad() {
        let story = Story(id: "id",
                          title: "test story",
                          user: User(name: "test_user",
                                     avatar: nil,
                                     fullname: nil),
                          cover: nil,
                          description: "test description",
                          tags: ["tag1", "tag2", "tag3"])
        let viewModel = MockStoryDetailViewModel(story: story,
                                                 error: nil)
        let view = StoryDetailViewController(viewModel: viewModel)
        
        isRecording = false
        assertSnapshot(matching: view,
                       as: .image(on: .iPadPro11,
                                  traits: UITraitCollection(userInterfaceStyle: .light)),
                       named: "light mode")
        assertSnapshot(matching: view,
                       as: .image(on: .iPadPro11,
                                  traits: UITraitCollection(userInterfaceStyle: .dark)),
                       named: "dark mode")
    }
}

private class MockStoryDetailViewModel: StoryDetailViewModelContract {
    var input: StoryDetailViewModelInput
    private struct InputBind: StoryDetailViewModelInput {
        var viewDidLoad: AnyObserver<Void>
    }
    
    var output: StoryDetailViewModelOutput
    private struct OutputBind: StoryDetailViewModelOutput {
        var story: Driver<Story?>
        var error: Driver<String>
    }
    
    init(story: Story?, error: String? = nil) {
        self.input = InputBind(viewDidLoad: PublishSubject<Void>().asObserver())
        self.output = OutputBind(story: BehaviorSubject(value: story).asDriver(onErrorJustReturn: nil),
                                 error: PublishSubject<String>().asDriver(onErrorJustReturn: ""))
    }
    
    func setImage(storyCover: Stories.AsyncImageView, url: URL?) {
        // no op needed in testing
        return
    }
}

//
//  StoryDetailViewModel.swift
//  Stories
//
//
//  
//

import Foundation
import RxSwift
import RxCocoa

protocol StoryDetailViewModelContract: StoriesViewModel
    where Input == StoryDetailViewModelInput, Output == StoryDetailViewModelOutput {
    func setImage(storyCover: AsyncImageView, url: URL?)
}

// MARK: Input
protocol StoryDetailViewModelInput {
    /// Triggered when the view did load.
    var viewDidLoad: AnyObserver<Void> { get }
}
private struct InputBind: StoryDetailViewModelInput {
    let viewDidLoad: AnyObserver<Void>
}

// MARK: Output
protocol StoryDetailViewModelOutput {
    /// The story on the detail page.
    var story: Driver<Story?> { get }
    /// An error message to display.
    var error: Driver<String> { get }
}
private struct OutputBind: StoryDetailViewModelOutput {
    let story: Driver<Story?>
    let error: Driver<String>
}

class StoryDetailViewModel: StoryDetailViewModelContract {
    let input: StoryDetailViewModelInput
    private let viewDidLoad = PublishSubject<Void>()

    let output: StoryDetailViewModelOutput
    private let story = BehaviorSubject<Story?>(value: nil)
    private let error = PublishSubject<String>()
    
    private let storyId: String
    private let environment: EnvironmentContract
    private let disposeBag = DisposeBag()

    required init(storyId: String,
                  environment: EnvironmentContract) {
        self.storyId = storyId
        self.environment = environment
        
        self.input = InputBind(viewDidLoad: viewDidLoad.asObserver())
        self.output = OutputBind(story: story.asDriver(onErrorJustReturn: nil),
                                 error: error.asDriver(onErrorJustReturn: ""))
        
        stories()
    }
    
    private func stories() {
        viewDidLoad.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.environment.api.get(request: StoriesRequests.StoryDetail(id: strongSelf.storyId), result: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let story):
                    strongSelf.story.onNext(story)
                case .failure(let error):
                    strongSelf.story.onNext(nil)
                    strongSelf.error.onNext(error.message)
                }
            })
        })
        .disposed(by: disposeBag)
    }
    
    func setImage(storyCover: AsyncImageView, url: URL?) {
        guard let url = url else { return }
        storyCover.setImage(url: url, imageManager: environment.api.imageManager)
    }
}

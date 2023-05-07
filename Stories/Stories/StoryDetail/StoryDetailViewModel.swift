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
struct StoryDetailViewModelInputBind: StoryDetailViewModelInput {
    var viewDidLoad: AnyObserver<Void> { return viewDidLoadBind.asObserver() }
    
    let viewDidLoadBind = PublishSubject<Void>()
}

// MARK: Output
protocol StoryDetailViewModelOutput {
    /// The story on the detail page.
    var story: Driver<Story?> { get }
    /// An error message to display.
    var error: Driver<String> { get }
}
struct StoryDetailViewModelOutputBind: StoryDetailViewModelOutput {
    var story: Driver<Story?> { return storyBind.asDriver(onErrorJustReturn: nil) }
    var error: Driver<String> { return errorBind.asDriver(onErrorJustReturn: "") }
    
    var storyBind = BehaviorSubject<Story?>(value: nil)
    var errorBind = PublishSubject<String>()
}

// MARK: ViewModel
class StoryDetailViewModel: StoryDetailViewModelContract {
    var input: StoryDetailViewModelInput { return inputBind }
    private let inputBind = StoryDetailViewModelInputBind()
    var output: StoryDetailViewModelOutput { return outputBind }
    private let outputBind = StoryDetailViewModelOutputBind()
    
    var coordinator: StoriesCoordinator

    private let storyId: String
    private let environment: EnvironmentContract
    private let disposeBag = DisposeBag()

    required init(storyId: String,
                  environment: EnvironmentContract,
                  coordinator: StoriesCoordinator) {
        self.storyId = storyId
        self.environment = environment
        self.coordinator = coordinator
        
        stories()
    }
    
    private func stories() {
        inputBind.viewDidLoadBind.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.environment.api.get(request: StoriesRequests.StoryDetail(id: strongSelf.storyId), result: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let story):
                    strongSelf.outputBind.storyBind.onNext(story)
                case .failure(let error):
                    strongSelf.outputBind.storyBind.onNext(nil)
                    strongSelf.outputBind.errorBind.onNext(error.message)
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

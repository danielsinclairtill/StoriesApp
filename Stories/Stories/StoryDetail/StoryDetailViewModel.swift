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

class StoryDetailViewModel: StoriesViewModel {
    // MARK: Input
    let input: Input
    struct Input {
        /// Triggered when the view did load.
        let viewDidLoad: AnyObserver<Void>
    }
    private let viewDidLoad = PublishSubject<Void>()

    // MARK: Output
    let output: Output
    struct Output {
        /// The story on the detail page.
        let story: Driver<Story?>
        /// An error message to display.
        let error: Driver<String>
    }
    private let story = PublishSubject<Story?>()
    private let error = PublishSubject<String>()
    
    private let storyId: String
    private let environment: EnvironmentContract
    private let disposeBag = DisposeBag()

    required init(storyId: String,
                  environment: EnvironmentContract) {
        self.storyId = storyId
        self.environment = environment
                
        self.input = Input(viewDidLoad: viewDidLoad.asObserver())
        self.output = Output(story: story.asDriver(onErrorJustReturn: nil),
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

//
//  StoryDetailViewModel.swift
//  Stories
//
//  Created by Daniel Till on 2023-08-22.
//

import Foundation
import Combine

protocol StoryDetailViewModelContract: StoriesViewModel
where Input == StoryDetailViewModelInput, Output == StoryDetailViewModelOutput {
    var imageManager: ImageManagerContract { get }
}

// MARK: Input
class StoryDetailViewModelInput: ObservableObject {
    /// The view did load.
    var viewDidLoad = PassthroughSubject<Void, Never>()
}

// MARK: Output
class StoryDetailViewModelOutput: ObservableObject {
    /// The story to display.
    @Published fileprivate(set) var story: Story?
    /// Show an error message to display over the story details.
    @Published fileprivate(set) var error: String = ""
}

// MARK: ViewModel
class StoryDetailViewModel: StoryDetailViewModelContract, ObservableObject {
    @Published var input = StoryDetailViewModelInput()
    @Published var output = StoryDetailViewModelOutput()
    private let coordinator: StoriesListCoordinator
    private var cancelBag = Set<AnyCancellable>()
    
    private let storyId: String
    private let environment: EnvironmentContract
    var imageManager: ImageManagerContract {
        return environment.api.imageManager
    }
    
    required init(storyId: String,
                  environment: EnvironmentContract,
                  coordinator: StoriesListCoordinator) {
        self.storyId = storyId
        self.environment = environment
        self.coordinator = coordinator
        
        // bind inputs and outputs
        setViewDidLoad()
    }
    
    private func setViewDidLoad() {
        input.viewDidLoad.sink { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.environment.api.get(request: StoriesRequests.StoryDetail(id: strongSelf.storyId), result: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let story):
                    strongSelf.output.story = story
                case .failure(let error):
                    strongSelf.output.story = nil
                    strongSelf.output.error = error.message
                }
            })
        }
        .store(in: &cancelBag)
    }
}

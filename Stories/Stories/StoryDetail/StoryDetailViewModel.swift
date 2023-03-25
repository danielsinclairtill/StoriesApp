//
//  StoryDetailViewModel.swift
//  Stories
//
//
//  
//

import Foundation

protocol StoryDetailViewModelOutputContract: NSObject {
    func presentError(message: String)
    func setStory(story: Story?)
}

class StoryDetailViewModel {
    private let storyId: String
    private(set) var story: Story?
    private let environment: EnvironmentContract
    weak var viewControllerDelegate: StoryDetailViewModelOutputContract?
    
    required init(storyId: String,
                  environment: EnvironmentContract) {
        self.storyId = storyId
        self.environment = environment
    }
    
    func loadStory() {
        environment.api.get(request: StoriesRequests.StoryDetail(id: storyId), result: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let story):
                strongSelf.story = story
                strongSelf.viewControllerDelegate?.setStory(story: story)
            case .failure(let error):
                strongSelf.viewControllerDelegate?.presentError(message: error.message)
                strongSelf.viewControllerDelegate?.setStory(story: nil)
            }
        })
    }
    
    func setImage(storyCover: AsyncImageView, url: URL?) {
        guard let url = url else { return }
        storyCover.setImage(url: url, imageManager: environment.api.imageManager)
    }
}

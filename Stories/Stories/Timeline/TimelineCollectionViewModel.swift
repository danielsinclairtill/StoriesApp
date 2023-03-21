//
//  TimelineCollectionViewModel.swift
//  Stories
//
//
//
//

import Foundation

// MARK: ViewModel
class TimelineCollectionViewModel {
    weak var viewControllerDelegate: TimelineCollectionViewControllerContract?
    private let environment: EnvironmentContract
    var stories: [Story] = []
    var isScrolling = false
    var isPagingLoading = false

    init(environment: EnvironmentContract) {
        self.environment = environment
    }
    
    func viewDidLoad() {
        if !environment.api.isConnectedToInternet() {
            viewControllerDelegate?.presentOfflineAlert(message: APIError.offline.message)
        } else {
            refresh()
        }
    }
    
    @objc func refresh() {
        viewControllerDelegate?.initiateLoadingTimeline()
        updateData()
    }
    
    @objc func refreshOffline() {
        viewControllerDelegate?.initiateLoadingTimeline()
        updateDataOffline()
    }
    
    @objc func loadNextPage() {
        guard !stories.isEmpty && !isPagingLoading else { return }
        isPagingLoading = true
        
        environment.api.get(request: StoriesRequests.StoriesTimelinePage(offset: self.stories.count + 1)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard !data.stories.isEmpty else {
                    // no stories were recieved, assume there is an issue with the API
                    strongSelf.viewControllerDelegate?.presentError(message: APIError.serverError.message)
                    return
                }
                
                strongSelf.stories += data.stories
                
                strongSelf.prefetchImages()
                strongSelf.viewControllerDelegate?.loadNextPage()
            case .failure(let error):
                strongSelf.viewControllerDelegate?.presentError(message: error.message)
            }
            
            strongSelf.isPagingLoading = false
        }
    }
    
    private func displayOfflineModeMessage() {
        // only show this bubble message once
        if !ApplicationManager.shared.hasSeenOfflineModeMessage {
            viewControllerDelegate?.presentBubbleMessage(
                message: "com.test.Stories.stories.bubbleMessage.offlineAvailable".localized()
            )
            ApplicationManager.shared.hasSeenOfflineModeMessage = true
        }
    }
    
    private func prefetchImages() {
        var prefetchImageURLs: [URL] = []
        stories.forEach { story in
            if let cover = story.cover {
                prefetchImageURLs.append(cover)
            }
            if let avatar = story.user?.avatar {
                prefetchImageURLs.append(avatar)
            }
        }

        environment.api.imageManager.prefetchImages(prefetchImageURLs, reset: true)
    }
    
    private func updateData() {
        environment.api.get(request: StoriesRequests.StoriesTimelinePage(), result: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard !data.stories.isEmpty else {
                    // no stories were recieved, assume there is an issue with the API
                    strongSelf.viewControllerDelegate?.presentError(message: APIError.serverError.message)
                    return
                }
                
                strongSelf.stories = data.stories
                // store stories for offline mode
                strongSelf.environment.store.storeStories(data.stories, success: { [weak self] completed in
                    self?.displayOfflineModeMessage()
                    }, failure: nil
                )
                strongSelf.prefetchImages()
                strongSelf.viewControllerDelegate?.reloadTimeline()
            case .failure(let error):
                strongSelf.viewControllerDelegate?.presentError(message: error.message)
            }
        })
    }
    
    private func updateDataOffline() {
        environment.store.getStories(success: { [weak self] stories in
            guard !stories.isEmpty else {
                // no stories were recieved, assume there is an issue with store read
                self?.viewControllerDelegate?.presentError(message: StoreError.readError.message)
                return
            }
            
            self?.stories = stories
            self?.viewControllerDelegate?.reloadTimeline()
        }) { [weak self] error in
            self?.viewControllerDelegate?.presentError(message: error.message)
        }
    }

    func configureCell(_ cell: TimelineCollectionViewCell, row: Int) {
        guard stories.indices.contains(row) else { return }

        cell.setUpWith(story: stories[row], imageManager: environment.api.imageManager)
    }

    func cellTapped(row: Int) {
        guard stories.indices.contains(row) else { return }

        viewControllerDelegate?.navigateToStory(stories[row])
    }
    
    func tabBarItemTappedWhileDisplayed(isAtTopOfView: Bool) {
        if !isScrolling && !isAtTopOfView {
            isScrolling = true
            viewControllerDelegate?.animateScrollToTop(animated: true)
        }
    }
}

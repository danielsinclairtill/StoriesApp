//
//  TimelineViewModel.swift
//  StoriesSwiftUI
//
//  Created by Daniel Till on 2023-04-09.
//

import Foundation
import Combine

protocol TimelineCollectionViewModelContract: StoriesViewModel {
    var imageManager: ImageManagerContract { get }
}

enum TimelineRefreshType {
    case offline
    case online
}

// MARK: Input
class TimelineCollectionViewModelInput: ObservableObject {
    var viewDidLoad = PassthroughSubject<Void, Never>()
    var refresh = PassthroughSubject<Void, Never>()
    var refreshBegin = PassthroughSubject<TimelineRefreshType, Never>()
    var loadNextPage = PassthroughSubject<Void, Never>()
    @Published var isScrolling: Bool = false
    @Published var isTopOfPage: Bool = true
    var cellTapped = PassthroughSubject<Int, Never>()
}

// MARK: Output
class TimelineCollectionViewModelOutput: ObservableObject {
    @Published var stories: [Story] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingNext: Bool = false
    @Published var isOffline: Bool = false
    @Published var error: String = ""
    @Published var bubbleMessage: String = ""
    @Published var scrollToTop: Void = ()
    @Published var navigateToStory: Story? = nil
}

// MARK: ViewModel
class TimelineCollectionViewModel: TimelineCollectionViewModelContract, ObservableObject {
    @Published var input = TimelineCollectionViewModelInput()
    @Published var output = TimelineCollectionViewModelOutput()
    private var cancelBag = Set<AnyCancellable>()
    
    private let environment: EnvironmentContract
    var imageManager: ImageManagerContract {
        return environment.api.imageManager
    }
    
    init(environment: EnvironmentContract) {
        self.environment = environment
        
        setViewDidLoad()
        setRefresh()
        setLoadNextPage()
        setCellTapped()
        
        output.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        .store(in: &cancelBag)
    }
    
    private func setViewDidLoad() {
        input.viewDidLoad.sink { [weak self] in
            guard let strongSelf = self else { return }
            if !strongSelf.environment.api.isConnectedToInternet() {
                strongSelf.output.error = APIError.offline.message
            } else {
                strongSelf.input.refreshBegin.send(.online)
                strongSelf.input.refresh.send(())
            }
        }
        .store(in: &cancelBag)
    }
    
    private func setRefresh() {
        input.refreshBegin.sink { [weak self] refreshType in
            guard let strongSelf = self else { return }
            strongSelf.output.isOffline = refreshType == .offline
            strongSelf.output.isLoading = true
        }
        .store(in: &cancelBag)
        
        // only initiate refresh is the refresh is wanted,
        // and all animations are completed before starting the refresh
        input.refresh.map { ($0, self.output.isOffline) }
            .sink { [weak self] _, isOffline in
                guard let strongSelf = self else { return }
                if isOffline {
                    strongSelf.updateDataOffline()
                } else {
                    strongSelf.updateData()
                }
            }
            .store(in: &cancelBag)
    }
    
    private func setLoadNextPage() {
        input.loadNextPage.map { ($0,
                                  self.output.stories,
                                  self.output.isLoadingNext,
                                  self.output.isOffline) }
        .throttle(for: 1.0,
                  scheduler: DispatchQueue.main,
                  latest: false)
        .filter { (_, stories, isLoadingNext, isOffline) in
            !isOffline &&
            !isLoadingNext &&
            !stories.isEmpty }
        .sink { [weak self] (_, stories, isLoading, isOffline) in
            guard let strongSelf = self else { return }
            strongSelf.output.isLoadingNext = true
            strongSelf.updateData(stories: stories)
        }
        .store(in: &cancelBag)
    }
    
    private func updateData(stories: [Story] = []) {
        environment.api.get(request: StoriesRequests.StoriesTimelinePage(offset: stories.count + 1)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard !data.stories.isEmpty else {
                    // no stories were recieved, assume there is an issue with the API
                    strongSelf.output.error = APIError.serverError.message
                    return
                }
                
                var newStories: [Story]
                if stories.count > 0 {
                    newStories = stories + data.stories
                } else {
                    newStories = data.stories
                    // store stories for offline mode
                    strongSelf.environment.store.storeStories(data.stories, success: { [weak self] completed in
                        self?.displayOfflineModeMessage()
                    }, failure: nil)
                }
                strongSelf.output.isOffline = false
                strongSelf.output.stories = newStories
                strongSelf.prefetchImages(stories: newStories)
                strongSelf.output.isLoading = false
                strongSelf.output.isLoadingNext = false
            case .failure(let error):
                strongSelf.output.error = error.message
                strongSelf.output.isLoading = false
                strongSelf.output.isLoadingNext = false
            }
        }
    }
    
    private func displayOfflineModeMessage() {
        // only show this bubble message once
        if !environment.state.hasSeenOfflineModeMessage {
            output.bubbleMessage = "com.test.Stories.stories.bubbleMessage.offlineAvailable".localized()
            environment.state.hasSeenOfflineModeMessage = true
        }
    }
    
    private func prefetchImages(stories: [Story]) {
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
    
    private func updateDataOffline() {
        environment.store.getStories(success: { [weak self] stories in
            guard let strongSelf = self else { return }
            guard !stories.isEmpty else {
                // no stories were recieved, assume there is an issue with store read
                strongSelf.output.error = StoreError.readError.message
                strongSelf.output.isLoading = false
                return
            }
            
            strongSelf.output.stories = stories
            strongSelf.output.isLoading = false
        }) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.output.error = error.message
            strongSelf.output.isLoading = false
        }
    }
    
    private func setCellTapped() {
        input.cellTapped.map { ($0, self.output.stories) }
            .sink { [weak self] (row, stories) in
                guard stories.indices.contains(row) else { return }
                self?.output.navigateToStory = stories[row]
            }
            .store(in: &cancelBag)
    }
    
    //    private func setTabBarItemTappedWhileDisplayed() {
    //        input.tabBarItemTapped.combineLatest(input.isTopOfPageBind,
    //                                                     input.isScrollingBind)
    //        .filter { isTopOfPage, isScrolling in !isTopOfPage && !isScrolling}
    //        .subscribe { [weak self] _, _ in
    //            self?.output.scrollToTopBind = ()
    //        }
    //        .disposed(by: disposeBag)
    //    }
}

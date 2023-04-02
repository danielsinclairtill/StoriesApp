//
//  TimelineCollectionViewModel.swift
//  Stories
//
//
//
//

import Foundation
import RxSwift
import RxCocoa

protocol TimelineCollectionViewModelContract: StoriesViewModel
where Input == TimelineCollectionViewModelInput, Output == TimelineCollectionViewModelOutput {
    var imageManager: ImageManagerContract { get }
}

enum TimelineRefreshType {
    case offline
    case online
}

// MARK: Input
protocol TimelineCollectionViewModelInput {
    /// Triggered when the view did load.
    var viewDidLoad: AnyObserver<Void> { get }
    /// Triggered when all animations on the stories timeline collection are complete, and it is ready to refresh the data.
    var refresh: AnyObserver<Void> { get }
    /// Triggered when the stories timeline collection wants to start to refresh. Either offline or online data.
    var refreshBegin: AnyObserver<TimelineRefreshType> { get }
    /// Triggered when the stories timeline collection wants to load the next page.
    var loadNextPage: AnyObserver<Void> { get }
    /// Is the timeline scrolling state.
    var isScrolling: AnyObserver<Bool> { get }
    /// Is the timeline at the top state.
    var isTopOfPage: AnyObserver<Bool> { get }
    /// Triggered when the tab bar item has been tapped while the view is displayed.
    var tabBarItemTapped: AnyObserver<Void> { get }
    /// Triggered when a story cell has been tapped.
    var cellTapped: AnyObserver<Int> { get }
}
struct TimelineCollectionViewModelInputBind: TimelineCollectionViewModelInput {
    var viewDidLoad: AnyObserver<Void> { return viewDidLoadBind.asObserver() }
    var refresh: AnyObserver<Void> { return refreshBind.asObserver() }
    var refreshBegin: AnyObserver<TimelineRefreshType> { return refreshBeginBind.asObserver() }
    var loadNextPage: AnyObserver<Void> { return loadNextPageBind.asObserver() }
    var isScrolling: AnyObserver<Bool> { return isScrollingBind.asObserver() }
    var isTopOfPage: AnyObserver<Bool> { return isTopOfPageBind.asObserver() }
    var tabBarItemTapped: AnyObserver<Void> { return tabBarItemTappedBind.asObserver() }
    var cellTapped: AnyObserver<Int> { return cellTappedBind.asObserver() }
    
    let viewDidLoadBind = PublishSubject<Void>()
    let refreshBind = PublishSubject<Void>()
    let refreshBeginBind = PublishSubject<TimelineRefreshType>()
    let loadNextPageBind = PublishSubject<Void>()
    let isScrollingBind = BehaviorSubject<Bool>(value: false)
    let isTopOfPageBind = BehaviorSubject<Bool>(value: false)
    let tabBarItemTappedBind = PublishSubject<Void>()
    let cellTappedBind = PublishSubject<Int>()
}

// MARK: Output
protocol TimelineCollectionViewModelOutput {
    /// The stories in the timeline collection.
    var stories: Driver<[Story]> { get }
    /// Is the timeline loading state.
    var isLoading: Driver<Bool> { get }
    /// Is the timeline loading the next page state.
    var isLoadingNext: Driver<Bool> { get }
    /// Is the timeline in offline mode state.
    var isOffline: Driver<Bool> { get }
    /// Show an error message with a message.
    var error: Driver<String> { get }
    /// Show a bubble message with a message.
    var bubbleMessage: Driver<String> { get }
    /// Scroll to the top of the timeline collection.
    var scrollToTop: Driver<Void> { get }
    /// Nativate to a story.
    var navigateToStory: Driver<Story?> { get }
}
struct TimelineCollectionViewModelOutputBind: TimelineCollectionViewModelOutput {
    var stories: Driver<[Story]> { return storiesBind.asDriver(onErrorJustReturn: []) }
    var isLoading: Driver<Bool> { return isLoadingBind.asDriver(onErrorJustReturn: false) }
    var isLoadingNext: Driver<Bool> { return isLoadingNextBind.asDriver(onErrorJustReturn: false) }
    var isOffline: Driver<Bool> { return isOfflineBind.asDriver(onErrorJustReturn: false) }
    var error: Driver<String> { return errorBind.asDriver(onErrorJustReturn: "") }
    var bubbleMessage: Driver<String> { return bubbleMessageBind.asDriver(onErrorJustReturn: "") }
    var scrollToTop: Driver<Void> { return scrollToTopBind.asDriver(onErrorJustReturn: ()) }
    var navigateToStory: Driver<Story?> { return navigateToStoryBind.asDriver(onErrorJustReturn: nil) }
    
    var storiesBind = BehaviorSubject<[Story]>(value: [])
    var isLoadingBind = BehaviorSubject<Bool>(value: true)
    var isLoadingNextBind = BehaviorSubject<Bool>(value: false)
    var isOfflineBind = BehaviorSubject<Bool>(value: false)
    var errorBind = PublishSubject<String>()
    var bubbleMessageBind = PublishSubject<String>()
    var scrollToTopBind = PublishSubject<Void>()
    var navigateToStoryBind = PublishSubject<Story?>()
}

// MARK: ViewModel
class TimelineCollectionViewModel: TimelineCollectionViewModelContract {
    var input: TimelineCollectionViewModelInput { return inputBind }
    private let inputBind = TimelineCollectionViewModelInputBind()
    var output: TimelineCollectionViewModelOutput { return outputBind }
    private let outputBind = TimelineCollectionViewModelOutputBind()
    
    private let environment: EnvironmentContract
    var imageManager: ImageManagerContract {
        return environment.api.imageManager
    }
    private let disposeBag = DisposeBag()
    
    init(environment: EnvironmentContract) {
        self.environment = environment
        
        setViewDidLoad()
        setRefresh()
        setLoadNextPage()
        setTabBarItemTappedWhileDisplayed()
        setCellTapped()
    }
    
    private func setViewDidLoad() {
        inputBind.viewDidLoadBind.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            if !strongSelf.environment.api.isConnectedToInternet() {
                strongSelf.outputBind.errorBind.onNext(APIError.offline.message)
            } else {
                strongSelf.updateData()
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func setRefresh() {
        inputBind.refreshBeginBind.subscribe(onNext: { [weak self] refreshType in
            guard let strongSelf = self else { return }
            strongSelf.outputBind.isOfflineBind.onNext(refreshType == .offline)
            strongSelf.outputBind.isLoadingBind.onNext(true)
        })
        .disposed(by: disposeBag)
        
        // only initiate refresh is the refresh is wanted,
        // and all animations are completed before starting the refresh
        inputBind.refreshBind.withLatestFrom(outputBind.isOfflineBind)
            .subscribe(onNext: { [weak self] isOffline in
                guard let strongSelf = self else { return }
                if isOffline {
                    strongSelf.updateDataOffline()
                } else {
                    strongSelf.updateData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setLoadNextPage() {
        inputBind.loadNextPageBind.withLatestFrom(Observable.combineLatest(outputBind.storiesBind,
                                                                           outputBind.isLoadingNextBind,
                                                                           outputBind.isOfflineBind))
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .filter { (stories, isLoadingNext, isOffline) in
                !isOffline &&
                !isLoadingNext &&
                !stories.isEmpty }
            .subscribe(onNext: { [weak self] (stories, isLoading, isOffline) in
                guard let strongSelf = self else { return }
                strongSelf.outputBind.isLoadingNextBind.onNext(true)
                strongSelf.updateData(stories: stories)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateData(stories: [Story] = []) {
        environment.api.get(request: StoriesRequests.StoriesTimelinePage(offset: stories.count + 1)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard !data.stories.isEmpty else {
                    // no stories were recieved, assume there is an issue with the API
                    strongSelf.outputBind.errorBind.onNext(APIError.serverError.message)
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
                strongSelf.outputBind.isOfflineBind.onNext(false)
                strongSelf.outputBind.storiesBind.onNext(newStories)
                strongSelf.prefetchImages(stories: newStories)
                strongSelf.outputBind.isLoadingBind.onNext(false)
                strongSelf.outputBind.isLoadingNextBind.onNext(false)
            case .failure(let error):
                strongSelf.outputBind.errorBind.onNext(error.message)
                strongSelf.outputBind.isLoadingBind.onNext(false)
                strongSelf.outputBind.isLoadingNextBind.onNext(false)
            }
        }
    }
    
    private func displayOfflineModeMessage() {
        // only show this bubble message once
        if !ApplicationManager.shared.hasSeenOfflineModeMessage {
            outputBind.bubbleMessageBind.onNext("com.test.Stories.stories.bubbleMessage.offlineAvailable".localized())
            ApplicationManager.shared.hasSeenOfflineModeMessage = true
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
                strongSelf.outputBind.errorBind.onNext(StoreError.readError.message)
                strongSelf.outputBind.isLoadingBind.onNext(false)
                return
            }
            
            strongSelf.outputBind.storiesBind.onNext(stories)
            strongSelf.outputBind.isLoadingBind.onNext(false)
        }) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.outputBind.errorBind.onNext(error.message)
            strongSelf.outputBind.isLoadingBind.onNext(false)
        }
    }
    
    private func setCellTapped() {
        inputBind.cellTappedBind.withLatestFrom(Observable.combineLatest(inputBind.cellTappedBind,
                                                                         outputBind.storiesBind))
        .subscribe(onNext: { [weak self] row, stories in
            guard stories.indices.contains(row) else { return }
            self?.outputBind.navigateToStoryBind.onNext(stories[row])
        })
        .disposed(by: disposeBag)
    }
    
    private func setTabBarItemTappedWhileDisplayed() {
        inputBind.tabBarItemTappedBind.withLatestFrom(Observable.combineLatest(inputBind.isTopOfPageBind,
                                                                               inputBind.isScrollingBind))
        .filter { isTopOfPage, isScrolling in !isTopOfPage && !isScrolling}
        .subscribe { [weak self] _, _ in
            self?.outputBind.scrollToTopBind.onNext(())
        }
        .disposed(by: disposeBag)
    }
}

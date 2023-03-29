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

class TimelineCollectionViewModel: StoriesViewModel {
    let input: Input
    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refresh: AnyObserver<Void>
        let refreshOffline: AnyObserver<Void>
        let loadNextPage: AnyObserver<Void>
        let isScrolling: AnyObserver<Bool>
        let isTopOfPage: AnyObserver<Bool>
        let tabBarItemTapped: AnyObserver<Void>
        let cellTapped: AnyObserver<Int>
    }
    private let viewDidLoad = PublishSubject<Void>()
    private let refresh = PublishSubject<Void>()
    private let refreshOffline = PublishSubject<Void>()
    private let loadNextPage = PublishSubject<Void>()
    private let isScrolling = BehaviorSubject<Bool>(value: false)
    private let isTopOfPage = BehaviorSubject<Bool>(value: false)
    private let tabBarItemTapped = PublishSubject<Void>()
    private let cellTapped = PublishSubject<Int>()
    
    let output: Output
    struct Output {
        let stories: Driver<[Story]>
        let isLoading: Driver<Bool>
        let isLoadingNext: Driver<Bool>
        let isOffline: Driver<Bool>
        let loadingCellSize: Driver<CGSize>
        let error: Driver<String>
        let bubbleMessage: Driver<String>
        let scrollToTop: Driver<Void>
        let navigateToStory: Driver<Story?>
    }
    private let stories = PublishSubject<[Story]>()
    private let isLoading = PublishSubject<Bool>()
    private let isLoadingNext = PublishSubject<Bool>()
    private let isOffline = PublishSubject<Bool>()
    private let loadingCellSize = PublishSubject<CGSize>()
    private let error = PublishSubject<String>()
    private let bubbleMessage = PublishSubject<String>()
    private let scrollToTop = PublishSubject<Void>()
    private let navigateToStory = PublishSubject<Story?>()
    
    private let environment: EnvironmentContract
    var imageManager: ImageManagerContract {
        return environment.api.imageManager
    }
    private let disposeBag = DisposeBag()
    
    init(environment: EnvironmentContract) {
        self.environment = environment
        
        self.input = Input(viewDidLoad: viewDidLoad.asObserver(),
                           refresh: refresh.asObserver(),
                           refreshOffline: refreshOffline.asObserver(),
                           loadNextPage: loadNextPage.asObserver(),
                           isScrolling: isScrolling.asObserver(),
                           isTopOfPage: isTopOfPage.asObserver(),
                           tabBarItemTapped: tabBarItemTapped.asObserver(),
                           cellTapped: cellTapped.asObserver())
        self.output = Output(stories: stories.asDriver(onErrorJustReturn: []),
                             isLoading: isLoading.asDriver(onErrorJustReturn: false),
                             isLoadingNext: isLoading.asDriver(onErrorJustReturn: false),
                             isOffline: isOffline.asDriver(onErrorJustReturn: true),
                             loadingCellSize: loadingCellSize.asDriver(onErrorJustReturn: .zero),
                             error: error.asDriver(onErrorJustReturn: ""),
                             bubbleMessage: bubbleMessage.asDriver(onErrorJustReturn: ""),
                             scrollToTop: scrollToTop.asDriver(onErrorJustReturn: ()),
                             navigateToStory: navigateToStory.asDriver(onErrorJustReturn: nil))
        
        setViewDidLoad()
        setRefresh()
        setRefreshOffline()
        setLoadNextPage()
        setTabBarItemTappedWhileDisplayed()
        setCellTapped()
    }
    
    private func setViewDidLoad() {
        viewDidLoad.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            if !strongSelf.environment.api.isConnectedToInternet() {
                strongSelf.error.onNext(APIError.offline.message)
            } else {
                strongSelf.refresh.onNext(())
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func setRefresh() {
        refresh.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLoading.onNext(true)
            strongSelf.updateData()
        })
        .disposed(by: disposeBag)
    }
    
    private func setRefreshOffline() {
        refreshOffline.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLoading.onNext(true)
            strongSelf.isOffline.onNext(true)
            strongSelf.updateDataOffline()
        })
        .disposed(by: disposeBag)
    }
    
    private func setLoadNextPage() {
        loadNextPage.withLatestFrom(Observable.combineLatest(stories, isLoadingNext))
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .filter { (stories, isLoadingNext) in isLoadingNext == false }
            .subscribe(onNext: { [weak self] (stories, isLoading) in
                guard let strongSelf = self else { return }
                strongSelf.isLoadingNext.onNext(true)
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
                    strongSelf.error.onNext(APIError.serverError.message)
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
                strongSelf.isOffline.onNext(false)
                strongSelf.stories.onNext(newStories)
                strongSelf.prefetchImages(stories: newStories)
                strongSelf.isLoading.onNext(false)
                strongSelf.isLoadingNext.onNext(false)
            case .failure(let error):
                strongSelf.error.onNext(error.message)
                strongSelf.isLoading.onNext(false)
                strongSelf.isLoadingNext.onNext(false)
            }
        }
    }
    
    private func displayOfflineModeMessage() {
        // only show this bubble message once
        if !ApplicationManager.shared.hasSeenOfflineModeMessage {
            bubbleMessage.onNext("com.test.Stories.stories.bubbleMessage.offlineAvailable".localized())
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
        isLoading.onNext(true)
        
        environment.store.getStories(success: { [weak self] stories in
            guard let strongSelf = self else { return }
            guard !stories.isEmpty else {
                // no stories were recieved, assume there is an issue with store read
                strongSelf.error.onNext(StoreError.readError.message)
                return
            }
            
            strongSelf.stories.onNext(stories)
        }) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.error.onNext(error.message)
        }
    }

    private func setCellTapped() {
        cellTapped.withLatestFrom(Observable.combineLatest(cellTapped, stories))
            .subscribe(onNext: { [weak self] row, stories in
                guard stories.indices.contains(row) else { return }
                self?.navigateToStory.onNext(stories[row])
            })
            .disposed(by: disposeBag)
    }
    
    private func setTabBarItemTappedWhileDisplayed() {
        tabBarItemTapped.withLatestFrom(Observable.combineLatest(isTopOfPage, isScrolling))
            .filter { isTopOfPage, isScrolling in isTopOfPage == false && isScrolling == false}
            .subscribe { [weak self] _, _ in
                self?.scrollToTop.onNext(())
            }
            .disposed(by: disposeBag)
    }
}

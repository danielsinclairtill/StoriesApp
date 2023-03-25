//
//  TimelineCollectionView2Controller.swift
//  Stories
//
//
//
//

import UIKit
import ViewAnimator
import Lottie

class TimelineCollectionViewController: StoriesViewController,
                                        UICollectionViewDelegateFlowLayout,
                                        UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UIScrollViewDelegate,
                                        UITabBarControllerDelegate,
                                        TimelineCollectionViewModelOutputContract,
                                        TabBarItemTapHandler {
    
    private let cellIdentifier = "TimelineCollectionViewCell"
    private let viewModel: TimelineCollectionViewModel
    // animation for displaying cells in collection view
    private let animations = [AnimationType.from(direction: .bottom, offset: 150.0)]
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingAnimationView: LottieAnimationView!
    @IBOutlet private weak var bubbleMessageViewContainer: UIView!
    private let refreshControl = UIRefreshControl()
    private var pagingLoadingView: TimelineCollectionViewPagingLoadingCell?

    init() {
        self.viewModel = TimelineCollectionViewModel(environment: StoriesEnvironment.shared)
        super.init(nibName: String(describing: TimelineCollectionViewController.self), bundle: nil)
        self.viewModel.viewControllerDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "com.test.Stories.stories.title".localized()
        view.backgroundColor = StoriesDesign.shared.attributes.colors.primary()

        // collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TimelineCollectionViewPagingLoadingCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: TimelineCollectionViewPagingLoadingCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(viewModel, action: #selector(viewModel.refresh), for: .valueChanged)
        collectionView.alpha = 0.0
        collectionView.backgroundColor = .clear
        
        // animation view
        loadingAnimationView.backgroundBehavior = .pauseAndRestore
        
        // bubble view
        bubbleMessageViewContainer.alpha = 0.0

        viewModel.viewDidLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // change the layout for collection view on iPad rotations
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIDevice.current.iPad ? collectionView.bounds.width / 2 : collectionView.bounds.width
        let height = TimelineCollectionViewCell.cellHeightToWidthRatio * width

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.isPagingLoading || viewModel.isOffline {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: TimelineCollectionViewPagingLoadingCell.cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: TimelineCollectionViewPagingLoadingCell.reuseIdentifier,
                                                                       for: indexPath) as! TimelineCollectionViewPagingLoadingCell
            view.backgroundColor = .clear
            pagingLoadingView = view
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.pagingLoadingView?.startLoading()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.pagingLoadingView?.stopLoading()
        }
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TimelineCollectionViewCell

        cell.setUp()
        viewModel.configureCell(cell, row: indexPath.row)
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.cellTapped(row: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > scrollView.contentSize.height - scrollView.bounds.height - TimelineCollectionViewPagingLoadingCell.cellHeight {
            viewModel.loadNextPage()
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        viewModel.isScrolling = false
    }
    
    // MARK: TimelineCollectionViewControllerContract
    func navigateToStory(_ story: Story) {
        guard let id = story.id else { return }
        navigationController?.pushViewController(StoryDetailViewController(storyId: id),
                                                 animated: true)
    }
    
    func initiateLoadingTimeline() {
        collectionView.isScrollEnabled = false
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
        AnimationController.fadeOutView(collectionView) { [weak self] completed in
            self?.refreshControl.endRefreshing()
        }
        AnimationController.fadeInView(loadingAnimationView, completion: nil)
    }
    
    func reloadTimeline() {
        collectionView.isScrollEnabled = true
        animateScrollToTop(animated: false)
        AnimationController.fadeOutView(loadingAnimationView,
                                        completion: { [weak self] completed in
                                            if completed {
                                                self?.loadingAnimationView.stop()
                                            }
        })
        
        collectionView.reloadData()
        collectionView.performBatchUpdates({
            AnimationController.fadeInView(collectionView, completion: nil)
            // use ViewAnimator library animation to display cells
            UIView.animate(views: collectionView.orderedVisibleCells,
                           animations: animations,
                           duration: AnimationController.fadeDuration,
                           completion: nil)
        }, completion: nil)
    }
    
    func loadNextPage() {
        collectionView.reloadData()
    }

    func presentOfflineAlert(message: String) {
        let alert = StoriesAlertControllerFactory.createOfflineAlert(message: message, closeHandler: { [weak self] _ in
            self?.viewModel.refreshOffline()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func presentError(message: String) {
        let alert = StoriesAlertControllerFactory.createAPIError(message: message, offlineHandler: { [weak self] _ in
            self?.viewModel.refreshOffline()
            }, refreshHandler: { [weak self] _ in
                self?.viewModel.refresh()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func presentBubbleMessage(message: String) {
        // do not present if bubble message is already being displayed
        guard bubbleMessageViewContainer.subviews.isEmpty else { return }
        let bubbleMessageView: BubbleMessageView = BubbleMessageView.instertInto(containerView: bubbleMessageViewContainer,
                                                                                 message: message)
        bubbleMessageViewContainer.addSubview(bubbleMessageView)
        AnimationController.fadeInView(bubbleMessageViewContainer, delay: 2.0) { [weak self] completed in
            guard let strongSelf = self else { return }
            AnimationController.fadeOutView(strongSelf.bubbleMessageViewContainer,
                                            delay: BubbleMessageView.displayTime,
                                            completion: { completed in
                bubbleMessageView.removeFromSuperview()
            })
        }
    }
    
    func animateScrollToTop(animated: Bool) {
        collectionView.setContentOffset(.zero, animated: animated)
    }
    
    // MARK: ThemeUpdated
    func themeUpdated(notification: Notification) {
        view.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        collectionView.reloadData()
    }
    
    // MARK: TabBarItemTapHandler
    func tabBarItemTappedWhileDisplayed() {
        viewModel.tabBarItemTappedWhileDisplayed(isAtTopOfView: collectionView.contentOffset == .zero)
    }
}

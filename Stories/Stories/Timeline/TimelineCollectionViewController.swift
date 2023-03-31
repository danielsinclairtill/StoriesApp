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
import RxSwift
import RxCocoa

class TimelineCollectionViewController: UIViewController,
                                        UICollectionViewDelegateFlowLayout,
                                        UICollectionViewDelegate,
                                        UIScrollViewDelegate,
                                        UITabBarControllerDelegate,
                                        TabBarItemTapHandler {
    private let cellIdentifier = "TimelineCollectionViewCell"
    private let viewModel: TimelineCollectionViewModel
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bubbleMessageViewContainer: UIView!
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()

    init() {
        self.viewModel = TimelineCollectionViewModel(environment: StoriesEnvironment.shared)
        super.init(nibName: String(describing: TimelineCollectionViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "com.test.Stories.stories.title".localized()

        // collection view
        collectionView.delegate = self
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TimelineCollectionViewPagingLoadingCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: TimelineCollectionViewPagingLoadingCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .clear
        
        // bubble view
        bubbleMessageViewContainer.alpha = 0.0
        
        bindViewModel()
        setupDesign()

        viewModel.input.viewDidLoad.onNext(())
    }
    
    private func bindViewModel() {
        // refresh control
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refresh)
            .disposed(by: disposeBag)
        viewModel.output.isLoading
            .drive(collectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        // stories collection
        viewModel.output.stories
            .drive(collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: TimelineCollectionViewCell.self)) { [weak self] collectionView, story, cell in
                guard let strongSelf = self else { return }
                cell.setUpWith(story: story, imageManager: strongSelf.viewModel.imageManager)
            }
            .disposed(by: disposeBag)
        
        // loading next page
        collectionView.rx.contentOffset
            .flatMap({ [weak self] contentOffset in
                guard let strongSelf = self else { return Signal<Void>.empty() }
                return strongSelf.collectionView.contentOffset.y + strongSelf.collectionView.frame.size.height + 80.0 > strongSelf.collectionView.contentSize.height ?
                    Signal.just(()) : Signal.empty()
            })
            .bind(to: viewModel.input.loadNextPage)
            .disposed(by: disposeBag)
        
        // scrolling to top
        collectionView.rx.contentOffset
            .map({ [weak self] contentOffset in
                guard let strongSelf = self else { return false }
                return strongSelf.collectionView.contentOffset == .zero
            })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isTopOfPage in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.isTopOfPage.onNext(isTopOfPage)
            })
            .disposed(by: disposeBag)
        viewModel.output.scrollToTop
            .drive(onNext: { [weak self] in
                self?.viewModel.input.isScrolling.onNext(true)
                self?.collectionView.setContentOffset(.zero, animated: true)
            })
            .disposed(by: disposeBag)
        
        // bubble message
        viewModel.output.bubbleMessage
            .drive(onNext: { message in
                self.presentBubbleMessage(message: message)
            })
            .disposed(by: disposeBag)
        
        // story selection
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.input.cellTapped.onNext(indexPath.row)
            })
            .disposed(by: disposeBag)
        
        // navigation
        viewModel.output.navigateToStory
            .drive(onNext: { [weak self] story in
                guard let story = story else { return }
                self?.navigateToStory(story)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDesign() {
        StoriesDesign.shared.output.theme
            .drive { [weak self] theme in
                guard let strongSelf = self else { return }
                strongSelf.view.backgroundColor = theme.attributes.colors.primary()
            }
            .disposed(by: disposeBag)
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
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        viewModel.input.isScrolling.onNext(false)
    }
    
    private func navigateToStory(_ story: Story) {
        guard let id = story.id else { return }
        navigationController?.pushViewController(StoryDetailViewController(storyId: id),
                                                 animated: true)
    }

    private func presentOfflineAlert(message: String) {
        let alert = StoriesAlertControllerFactory.createOfflineAlert(message: message, closeHandler: { [weak self] _ in
            self?.viewModel.input.refreshOffline.onNext(())
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func presentError(message: String) {
        let alert = StoriesAlertControllerFactory.createAPIError(message: message, offlineHandler: { [weak self] _ in
            self?.viewModel.input.refreshOffline.onNext(())
            }, refreshHandler: { [weak self] _ in
                self?.viewModel.input.refresh.onNext(())
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func presentBubbleMessage(message: String) {
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
    
    // MARK: TabBarItemTapHandler
    func tabBarItemTappedWhileDisplayed() {
        viewModel.input.tabBarItemTapped.onNext(())
    }
}

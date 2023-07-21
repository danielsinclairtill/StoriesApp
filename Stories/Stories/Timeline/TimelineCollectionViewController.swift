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
import Combine

class TimelineCollectionViewController: UIViewController,
                                        UICollectionViewDelegateFlowLayout,
                                        UICollectionViewDelegate,
                                        UIScrollViewDelegate,
                                        UITabBarControllerDelegate {
    private let cellIdentifier = "TimelineCollectionViewCell"
    private let viewModel: any TimelineCollectionViewModelContract

    enum SectionKind: Int, CaseIterable {
      case main
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Story>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, Story>
    private var dataSource: DataSource?

    @IBOutlet private weak var loadingAnimationView: LottieAnimationView!
    @IBOutlet private weak var bubbleMessageViewContainer: UIView!
    private let refreshControl = UIRefreshControl()
    private var observation: NSKeyValueObservation?
    private var cancelBag = Set<AnyCancellable>()

    init(viewModel: any TimelineCollectionViewModelContract) {
        self.viewModel = viewModel
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
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .clear
        collectionView.alpha = 0.0
        
        // bubble view
        bubbleMessageViewContainer.isHidden = true
        bubbleMessageViewContainer.alpha = 0.0
        
        // animation view
        loadingAnimationView.isHidden = false
        loadingAnimationView.backgroundBehavior = .pauseAndRestore
        
        bindViewModel()
        setupDesign()

        viewModel.input.viewDidLoad.send(())
    }
    
    @objc
    func didPullRefresh(_ sender: AnyObject) {
        viewModel.input.refreshBegin.send(.online)
    }
    
    private func bindViewModel() {
        // refresh control
        refreshControl.addTarget(self, action: #selector(self.didPullRefresh(_:)), for: .valueChanged)
        viewModel.output.$isLoading
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.collectionView.refreshControl?.beginRefreshing()
                } else {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            })
            .store(in: &cancelBag)
        
        // loading timeline animation
        viewModel.output.$isLoading
            // make sure animating between loading states is buffered by at least 0.8 seconds
            .removeDuplicates()
            .throttle(for: 0.8,
                      scheduler: DispatchQueue.main,
                      latest: false)
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.initiateLoadingTimeline()
                } else {
                    self?.finishLoadingTimeline()
                }
            })
            .store(in: &cancelBag)
        
        // stories collection
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, story in
            guard let strongSelf = self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: strongSelf.cellIdentifier,
                                                                for: indexPath) as? TimelineCollectionViewCell else {
                assertionFailure("could not dequeue an cell")
                return UICollectionViewCell()
            }
            
            cell.setUpWith(story: story, imageManager: strongSelf.viewModel.imageManager)
            
            return cell
        })
        viewModel.output.$stories
            .sink { [weak self] stories in
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(stories)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancelBag)
        
        observation = collectionView.observe(\.contentOffset, options: .new) { [weak self] collectionView, change in
            guard let strongSelf = self else { return }
            
            // loading next page
            if strongSelf.collectionView.contentOffset.y + strongSelf.collectionView.frame.size.height + strongSelf.getCellSize().height > strongSelf.collectionView.contentSize.height {
                strongSelf.viewModel.input.loadNextPage.send(())
            }
            
            // scrolling to top
            strongSelf.viewModel.input.isTopOfPage = strongSelf.collectionView.contentOffset == .zero
        }

        viewModel.output.$scrollToTop
            .sink(receiveValue: { [weak self] in
                self?.viewModel.input.isScrolling = true
                self?.collectionView.setContentOffset(.zero, animated: true)
            })
            .store(in: &cancelBag)

        // error message
        viewModel.output.$error
            .filter { !$0.isEmpty }
            .sink(receiveValue: { [weak self] message in
                self?.presentError(message: message)
            })
            .store(in: &cancelBag)

        // bubble message
        viewModel.output.$bubbleMessage
            .filter { !$0.isEmpty }
            .sink(receiveValue: { [weak self] message in
                self?.presentBubbleMessage(message: message)
            })
            .store(in: &cancelBag)
    }
    
    private func setupDesign() {
//        StoriesDesign.shared.output.theme
//            .drive { [weak self] theme in
//                guard let strongSelf = self else { return }
//                strongSelf.view.backgroundColor = theme.attributes.colors.primary()
//            }
//            .store(in: &cancelBag)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // change the layout for collection view on iPad rotations
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func getCellSize() -> CGSize {
        // large width class devices should show two columns in the collection view
        let isLargeWidth = UITraitCollection.current.horizontalSizeClass == .regular
        let width = isLargeWidth ? collectionView.bounds.width / 2 : collectionView.bounds.width
        let height = TimelineCollectionViewCell.cellHeightToWidthRatio * width
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.cellTapped.send(indexPath.row)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize()
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
        viewModel.input.isScrolling = false
    }

    private func presentOfflineAlert(message: String) {
        let alert = StoriesAlertControllerFactory.createOfflineAlert(message: message, closeHandler: { [weak self] _ in
            self?.viewModel.input.refreshBegin.send(.offline)
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func presentError(message: String) {
        let alert = StoriesAlertControllerFactory.createAPIError(message: message, offlineHandler: { [weak self] _ in
            self?.viewModel.input.refreshBegin.send(.offline)
            }, refreshHandler: { [weak self] _ in
                self?.viewModel.input.refreshBegin.send(.online)
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func presentBubbleMessage(message: String) {
        // do not present if bubble message is already being displayed
        guard bubbleMessageViewContainer.subviews.isEmpty else { return }
        let bubbleMessageView: BubbleMessageView = BubbleMessageView.instertInto(containerView: bubbleMessageViewContainer,
                                                                                 message: message)
        bubbleMessageViewContainer.isHidden = false
        bubbleMessageViewContainer.addSubview(bubbleMessageView)
        AnimationController.fadeInView(bubbleMessageViewContainer, delay: 2.0) { [weak self] completed in
            guard let strongSelf = self else { return }
            AnimationController.fadeOutView(strongSelf.bubbleMessageViewContainer,
                                            delay: BubbleMessageView.displayTime,
                                            completion: { completed in
                strongSelf.bubbleMessageViewContainer.isHidden = true
                bubbleMessageView.removeFromSuperview()
            })
        }
    }
    
    private func initiateLoadingTimeline() {
        collectionView.isScrollEnabled = false
        loadingAnimationView.isHidden = false
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
        AnimationController.fadeOutView(collectionView) { [weak self] completed in
            self?.refreshControl.endRefreshing()
            self?.viewModel.input.refresh.send(())
        }
        AnimationController.fadeInView(loadingAnimationView, completion: nil)
    }
    
    private func finishLoadingTimeline() {
        AnimationController.fadeOutView(loadingAnimationView,
                                        completion: { [weak self] completed in
            if completed {
                self?.loadingAnimationView.stop()
                self?.loadingAnimationView.isHidden = true
            }
        })
        AnimationController.fadeInView(collectionView) { [weak self] completed in
            self?.collectionView.isScrollEnabled = true
        }
    }
}

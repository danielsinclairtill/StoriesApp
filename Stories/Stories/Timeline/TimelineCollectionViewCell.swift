//
//  TimelineCollectionViewCell.swift
//  Stories
//
//
//
//

import UIKit
import RxSwift

class TimelineCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var storyContentView: UIView!
    @IBOutlet private weak var coverImageContainer: UIView!
    private  let coverImage: AsyncImageView = AsyncImageView(placeholderImage: nil,
                                                             cornerRadius: StoriesDesign.shared.theme.attributes.dimensions.coverCornerRadius())
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var avatarImageContainer: UIView!
    private let avatarImage: AsyncImageView = AvatarView(placeholderImage: UIImage(named: "UnkownUser"),
                                                         size: 32)
    @IBOutlet private weak var authorTitle: UILabel!
    
    static let cellHeightToWidthRatio: CGFloat = 0.5
    
    private let animationController = AnimationController()
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // cover
        addSubview(coverImage)
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: coverImageContainer.topAnchor),
            coverImage.bottomAnchor.constraint(equalTo: coverImageContainer.bottomAnchor),
            coverImage.leadingAnchor.constraint(equalTo: coverImageContainer.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: coverImageContainer.trailingAnchor),
        ])
        
        // avatar
        addSubview(avatarImage)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: avatarImageContainer.topAnchor),
            avatarImage.bottomAnchor.constraint(equalTo: avatarImageContainer.bottomAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: avatarImageContainer.leadingAnchor),
            avatarImage.trailingAnchor.constraint(equalTo: avatarImageContainer.trailingAnchor),
        ])
        
        // title
        title.text = nil
        title.adjustsFontForContentSizeCategory = true
        
        // author title
        authorTitle.text = nil
        authorTitle.adjustsFontForContentSizeCategory = true
    }
    
    func setUpWith(story: Story, imageManager: ImageManagerContract) {
        title.text = story.title
        authorTitle.text = story.user?.name

        if let coverUrl = story.cover {
            coverImage.setImage(url: coverUrl, imageManager: imageManager)
        }
        
        if let avatarUrl = story.user?.avatar {
            avatarImage.setImage(url: avatarUrl, imageManager: imageManager)
        }

        setupDesign()
    }
    
    private func setupDesign() {
        StoriesDesign.shared.output.theme
            .drive(onNext: { [weak self] theme in
                guard let strongSelf = self else { return }
                strongSelf.backgroundColor = theme.attributes.colors.primary()
                strongSelf.storyContentView.backgroundColor = theme.attributes.colors.primary()
                                
                strongSelf.title.font = theme.attributes.fonts.primaryTitle()
                strongSelf.title.textColor = theme.attributes.colors.primaryFill()
                
                strongSelf.authorTitle.font = theme.attributes.fonts.body()
                strongSelf.authorTitle.textColor = theme.attributes.colors.primaryFill()
            })
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title.text = nil
        authorTitle.text = ""

        coverImage.clearImage()
        avatarImage.clearImage()
        
        disposeBag = DisposeBag()
    }
    
    // MARK:- Animations
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animationController.createTapBounceAnitmationOnTouchBeganTo(view: coverImage)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animationController.createTapBounceAnitmationOnTouchEndedTo(view: coverImage)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animationController.createTapBounceAnitmationOnTouchCancelledTo(view: coverImage)
    }
}

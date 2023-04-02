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
    @IBOutlet private weak var coverImageContainerView: UIView!
    @IBOutlet private weak var coverImagePlaceholderView: UIView!
    @IBOutlet private weak var coverImage: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var avatarPlaceholderImageView: UIImageView!
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var authorTitle: UILabel!

    static let cellHeightToWidthRatio: CGFloat = 0.5
    
    private let animationController = AnimationController()
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // cover image
        coverImagePlaceholderView.alpha = 1.0
        coverImage.image = nil
        coverImage.contentMode = .scaleAspectFill
        coverImage.alpha = 0.0
        coverImage.clipsToBounds = true
        
        // title
        title.text = nil
        title.adjustsFontForContentSizeCategory = true
        
        // avatar image
        avatarPlaceholderImageView.image = #imageLiteral(resourceName: "UnkownUser")
        avatarPlaceholderImageView.alpha = 1.0
        avatarPlaceholderImageView.layer.masksToBounds = false
        avatarPlaceholderImageView.layer.cornerRadius = avatarPlaceholderImageView.frame.height / 2
        avatarPlaceholderImageView.clipsToBounds = true

        avatarImage.image = nil
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.alpha = 0.0
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true

        // author title
        authorTitle.text = nil
        authorTitle.adjustsFontForContentSizeCategory = true
    }
    
    func setUpWith(story: Story, imageManager: ImageManagerContract) {
        imageManager.setImageView(imageView: coverImage,
                                  placeholder: coverImagePlaceholderView,
                                  url: story.cover)
        title.text = story.title
        imageManager.setImageView(imageView: avatarImage,
                                  placeholder: avatarPlaceholderImageView,
                                  url: story.user?.avatar)
        authorTitle.text = story.user?.name
        
        setupDesign()
    }
    
    private func setupDesign() {
        StoriesDesign.shared.output.theme
            .drive(onNext: { [weak self] theme in
                guard let strongSelf = self else { return }
                strongSelf.backgroundColor = theme.attributes.colors.primary()
                strongSelf.storyContentView.backgroundColor = theme.attributes.colors.primary()
                
                strongSelf.coverImagePlaceholderView.backgroundColor = theme.attributes.colors.temporary()
                strongSelf.coverImagePlaceholderView.layer.cornerRadius = theme.attributes.dimensions.coverCornerRadius()
                
                strongSelf.coverImage.layer.cornerRadius = theme.attributes.dimensions.coverCornerRadius()
                
                strongSelf.title.font = theme.attributes.fonts.primaryTitle()
                
                strongSelf.title.textColor = theme.attributes.colors.primaryFill()
                
                strongSelf.authorTitle.font = theme.attributes.fonts.body()
                strongSelf.authorTitle.textColor = theme.attributes.colors.primaryFill()
            })
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImage.image = nil
        title.text = nil
        avatarImage.image = nil
        authorTitle.text = ""
        
        disposeBag = DisposeBag()
    }
    
    // MARK:- Animations
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animationController.createTapBounceAnitmationOnTouchBeganTo(view: coverImageContainerView)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animationController.createTapBounceAnitmationOnTouchEndedTo(view: coverImageContainerView)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animationController.createTapBounceAnitmationOnTouchCancelledTo(view: coverImageContainerView)
    }
}

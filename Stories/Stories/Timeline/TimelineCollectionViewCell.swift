//
//  TimelineCollectionViewCell.swift
//  Stories
//
//
//
//

import UIKit

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

    func setUp() {
        // background
        backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        storyContentView.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        
        // cover image
        coverImagePlaceholderView.alpha = 1.0
        coverImagePlaceholderView.backgroundColor = StoriesDesign.shared.attributes.colors.temporary()
        coverImagePlaceholderView.layer.cornerRadius = StoriesDesign.shared.attributes.dimensions.coverCornerRadius()

        coverImage.image = nil
        coverImage.contentMode = .scaleAspectFill
        coverImage.alpha = 0.0
        coverImage.layer.cornerRadius = StoriesDesign.shared.attributes.dimensions.coverCornerRadius()
        coverImage.clipsToBounds = true
        
        // title
        title.text = nil
        title.font = StoriesDesign.shared.attributes.fonts.primaryTitle()
        title.adjustsFontForContentSizeCategory = true
        title.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        
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
        authorTitle.font = StoriesDesign.shared.attributes.fonts.body()
        authorTitle.adjustsFontForContentSizeCategory = true
        authorTitle.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
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

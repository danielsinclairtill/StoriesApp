//
//  StoryDetailViewController.swift
//  Stories
//
//
//  
//

import Foundation
import UIKit
import TagListView

class StoryDetailViewController: StoriesViewController,
                                 StoryDetailViewModelOutputContract {
    private let viewModel: StoryDetailViewModel
    
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var storyCover = AsyncImageView(placeholderImage: nil,
                                                 cornerRadius: StoriesDesign.shared.attributes.dimensions.coverCornerRadius())
    
    private lazy var storyTitle: UILabel = {
        let label = UILabel()
        label.font = StoriesDesign.shared.attributes.fonts.primaryTitleLarge()
        label.adjustsFontForContentSizeCategory = true
        label.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var avatarView: AvatarView = {
        let avatar = AvatarView(placeholderImage: UIImage(named: "UnkownUser"),
                                size: 30.0)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        return avatar
    }()
    
    private lazy var descrptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8.0
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var authorTitle: UILabel = {
        let label = UILabel()
        label.font = StoriesDesign.shared.attributes.fonts.primaryTitle()
        label.adjustsFontForContentSizeCategory = true
        label.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let label = UILabel()
        label.font = StoriesDesign.shared.attributes.fonts.body()
        label.adjustsFontForContentSizeCategory = true
        label.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var tagsListView: TagListView = {
        let tagsListView = TagListView()
        tagsListView.textFont = StoriesDesign.shared.attributes.fonts.body()
        tagsListView.textColor = StoriesDesign.shared.attributes.colors.secondaryFill()
        tagsListView.tagBackgroundColor = StoriesDesign.shared.attributes.colors.secondary()
        tagsListView.alignment = .leading
        tagsListView.cornerRadius = StoriesDesign.shared.attributes.dimensions.tagCornerRadius()
        tagsListView.backgroundColor = .clear
        tagsListView.translatesAutoresizingMaskIntoConstraints = false
        
        return tagsListView
    }()
    
    init(storyId: String) {
        self.viewModel = StoryDetailViewModel(storyId: storyId, environment: StoriesEnvironment.shared)

        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.viewControllerDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        
        // layout subviews
        // rootStackView
        view.addSubview(rootStackView)
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            rootStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            rootStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            rootStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        // story cover and title
        rootStackView.addArrangedSubview(storyCover)
        NSLayoutConstraint.activate([
            storyCover.widthAnchor.constraint(equalTo: storyCover.heightAnchor, multiplier: 0.64),
            storyCover.widthAnchor.constraint(equalToConstant: 150)
        ])
        rootStackView.addArrangedSubview(storyTitle)
        
        // description section
        rootStackView.addArrangedSubview(descrptionStackView)
        NSLayoutConstraint.activate([
            descrptionStackView.widthAnchor.constraint(equalTo: rootStackView.widthAnchor),
        ])
        // author
        authorStackView.addArrangedSubview(avatarView)
        authorStackView.addArrangedSubview(authorTitle)
        descrptionStackView.addArrangedSubview(authorStackView)

        // description
        // make the descriptionTitle be the first the compress if the vertical spacing cannot fit all elements
        descriptionTitle.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        descrptionStackView.addArrangedSubview(descriptionTitle)
        descrptionStackView.addArrangedSubview(tagsListView)
        // add heightConstraint to ensure that the tagsListView height grows depending on the amount of tags
        let heightConstraint = tagsListView.heightAnchor.constraint(greaterThanOrEqualToConstant: 18.0)
        heightConstraint.priority = .init(250.0)
        NSLayoutConstraint.activate([
            tagsListView.widthAnchor.constraint(equalTo: descrptionStackView.widthAnchor),
            heightConstraint
        ])
                
        // load story detail
        viewModel.loadStory()
    }
    
    func setStory(story: Story?) {
        viewModel.setImage(storyCover: storyCover, url: story?.cover)
        storyTitle.text = story?.title ?? "..."
        viewModel.setImage(storyCover: avatarView, url: story?.user?.avatar)
        authorTitle.text = story?.user?.name ?? "..."
        descriptionTitle.text = story?.description ?? "..."
        
        // reset all the tags in the tags stack view
        tagsListView.removeAllTags()
        // only take the first five tags of the story
        if let tags = story?.tags?.prefix(5) {
            let formattedTags = Array(tags).map({ return "#\($0)" })
            tagsListView.addTags(formattedTags)
        }
    }
    
    func presentError(message: String) {
        let alert = StoriesAlertControllerFactory.createAPIError(message: message)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: ThemeUpdated
    func themeUpdated(notification: Notification) {
        view.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        storyTitle.font = StoriesDesign.shared.attributes.fonts.primaryTitleLarge()
        storyTitle.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        authorTitle.font = StoriesDesign.shared.attributes.fonts.primaryTitle()
        authorTitle.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        descriptionTitle.font = StoriesDesign.shared.attributes.fonts.body()
        descriptionTitle.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        tagsListView.textFont = StoriesDesign.shared.attributes.fonts.body()
        tagsListView.textColor = StoriesDesign.shared.attributes.colors.secondaryFill()
        tagsListView.tagBackgroundColor = StoriesDesign.shared.attributes.colors.secondary()
        tagsListView.cornerRadius = StoriesDesign.shared.attributes.dimensions.tagCornerRadius()
    }
}

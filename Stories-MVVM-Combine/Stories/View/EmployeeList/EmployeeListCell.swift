//
//  EmployeeListCell.swift
//  SquareTakeHome
//
//
//

import Foundation
import UIKit
import Combine

class EmployeeListCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 160
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        return stackView
    }()
    
    private lazy var detailStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var photoView: AsyncImageView = {
        return AsyncImageView(placeholderImage: UIImage(named: "UnkownUser"),
                              cornerRadius: SquareTakeHomeDesign.shared.theme.attributes.dimensions.photoCornerRadius())
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var team: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var biography: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        // base container stack
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalStack)
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])
        
        // photo
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.widthAnchor.constraint(equalToConstant: 100),
            photoView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        horizontalStack.addArrangedSubview(photoView)
        
        // detail stack
        horizontalStack.addArrangedSubview(detailStack)
        
        // name
        detailStack.addArrangedSubview(name)
        
        // team
        team.setContentHuggingPriority(.defaultLow, for: .vertical)
        detailStack.addArrangedSubview(team)
        
        // biography
        biography.setContentHuggingPriority(.defaultLow, for: .vertical)
        detailStack.addArrangedSubview(biography)
    }
    
    private func setupDesign() {
        SquareTakeHomeDesign.shared.$theme
            .sink { [weak self] theme in
                guard let strongSelf = self else { return }
                strongSelf.backgroundColor = theme.attributes.colors.primary()
                
                strongSelf.photoView.setCornerRadius(theme.attributes.dimensions.photoCornerRadius())
                
                strongSelf.name.font = theme.attributes.fonts.primaryTitle()
                strongSelf.name.textColor = theme.attributes.colors.primaryFill()
                strongSelf.team.font = theme.attributes.fonts.primaryTitle()
                strongSelf.team.textColor = theme.attributes.colors.primaryFill()
                strongSelf.biography.font = theme.attributes.fonts.body()
                strongSelf.biography.textColor = theme.attributes.colors.primaryFill()
            }
            .store(in: &cancelBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        name.text = ""
        team.text = ""
        biography.text = ""
        photoView.clearImage()
        
        cancelBag = Set<AnyCancellable>()
    }
    
    func setUpWith(employee: Employee,
                   imageManager: ImageManagerContract) {
        name.text = employee.fullName
        team.text = "#\(employee.team)"
        biography.text = employee.biography ?? ""
        
        if let photoUrl = employee.photoUrlSmall {
            photoView.setImage(url: photoUrl,
                               imageManager: imageManager)
        }
        
        setupDesign()
    }
}

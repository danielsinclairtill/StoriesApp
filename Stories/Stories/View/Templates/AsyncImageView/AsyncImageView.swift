//
//  AsyncImageView.swift
//  Stories
//
//
//  
//

import Foundation
import UIKit

class AsyncImageView: UIView {
    private let placeholderImage: UIImage?
    private let cornerRadius: CGFloat
    
    private lazy var placeholder: UIImageView = {
        let placeholder = UIImageView()
        placeholder.image = placeholderImage
        placeholder.alpha = 1.0
        placeholder.backgroundColor = StoriesDesign.shared.theme.attributes.colors.temporary()
        placeholder.layer.cornerRadius = cornerRadius
        placeholder.clipsToBounds = true

        return placeholder
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.contentMode = .scaleAspectFill
        image.alpha = 0.0
        image.layer.cornerRadius = cornerRadius
        image.clipsToBounds = true
        
        return image
    }()
    
    required init(placeholderImage: UIImage?,
                  cornerRadius: CGFloat = 0.0,
                  frame: CGRect = .zero) {
        self.placeholderImage = placeholderImage
        self.cornerRadius = cornerRadius
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        clipsToBounds = true
        
        // layoutsubviews
        addSubview(placeholder)
        addSubview(image)
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: topAnchor),
            placeholder.bottomAnchor.constraint(equalTo: bottomAnchor),
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: URL,
                  imageManager: ImageManagerContract) {
        imageManager.setImageView(imageView: image,
                                  placeholder: placeholder,
                                  url: url)
    }
}

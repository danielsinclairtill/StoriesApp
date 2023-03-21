//
//  BubbleMessageView.swift
//  Stories
//
//
//
//

import UIKit

class BubbleMessageView: UIView {
    /// Time for how long the bubble message view should ideally be displayed.
    static let displayTime: TimeInterval = 7.0
    @IBOutlet private weak var messageLabel: UILabel!
    
    static func instertInto(containerView: UIView, message: String) -> BubbleMessageView {
        let bubbleMessageView = Bundle.main.loadNibNamed(String(describing: BubbleMessageView.self), owner: nil, options: nil)?.first as! BubbleMessageView
        
        bubbleMessageView.layer.shadowColor = StoriesDesign.shared.attributes.colors.primaryFill().cgColor
        bubbleMessageView.layer.shadowOpacity = 0.2
        bubbleMessageView.layer.shadowOffset = .zero
        bubbleMessageView.layer.shadowRadius = 5
        
        bubbleMessageView.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        bubbleMessageView.layer.cornerRadius = 4.0
        bubbleMessageView.messageLabel.text = message
        bubbleMessageView.messageLabel.numberOfLines = 2
        bubbleMessageView.messageLabel.font = StoriesDesign.shared.attributes.fonts.primaryTitle()
        bubbleMessageView.messageLabel.textColor = StoriesDesign.shared.attributes.colors.primaryFill()
        bubbleMessageView.frame = containerView.bounds
        
        return bubbleMessageView
    }
}

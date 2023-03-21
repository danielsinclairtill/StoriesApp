//
//  TimelineCollectionViewPagingLoadingCell.swift
//  Stories
//
//
//  
//

import Foundation
import UIKit

class TimelineCollectionViewPagingLoadingCell: UICollectionReusableView {
    static let reuseIdentifier = "TimelineCollectionViewPagingLoadingCell"
    static let cellHeight: CGFloat = 100
    private let spinnerView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        spinnerView.color = StoriesDesign.shared.attributes.colors.primaryFill()
        addSubview(spinnerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spinnerView.center = CGPoint(x: self.bounds.width / 2,
                                     y: self.bounds.height / 2)
    }
    
    func startLoading() {
        spinnerView.startAnimating()
    }
    
    func stopLoading() {
        spinnerView.stopAnimating()
    }
}

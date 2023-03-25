//
//  TimelineCollectionViewPagingLoadingCell.swift
//  Stories
//
//
//  
//

import Foundation
import UIKit
import RxSwift

class TimelineCollectionViewPagingLoadingCell: UICollectionReusableView {
    static let reuseIdentifier = "TimelineCollectionViewPagingLoadingCell"
    static let cellHeight: CGFloat = 100
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        StoriesDesign.shared.output.theme
            .drive { [weak self] theme in
                self?.spinnerView.color = theme.attributes.colors.primaryFill()
            }
            .disposed(by: disposeBag)
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

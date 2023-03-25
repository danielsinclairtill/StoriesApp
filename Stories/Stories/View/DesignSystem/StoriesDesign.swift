//
//  StoriesDesign.swift
//  Stories
//
//
//
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class StoriesDesign {
    static let shared = StoriesDesign(theme: ApplicationManager.shared.theme)
    var output: Output
    struct Output {
        let theme: Driver<StoriesDesignTheme>
    }
    private var design: BehaviorSubject<StoriesDesignTheme>?
    private(set) var theme: StoriesDesignTheme
    
    init(theme: StoriesDesignTheme = .plain) {
        self.theme = theme

        let design = BehaviorSubject<StoriesDesignTheme>(value: self.theme)
        self.design = design
        self.output = StoriesDesign.Output(theme: design.asDriver(onErrorJustReturn: self.theme))
    }
    
    func changeToTheme(_ theme: StoriesDesignTheme) {
        self.theme = theme
        
        ApplicationManager.shared.theme = theme
        design?.onNext(theme)
    }
}

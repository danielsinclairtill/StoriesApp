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
    static let shared = StoriesDesign()
    var output: Output
    struct Output {
        let theme: Driver<StoriesDesignTheme>
    }
    private var design: BehaviorSubject<StoriesDesignTheme>?
    private(set) var theme: StoriesDesignTheme
    private(set) var state: ApplicationStateContract
    
    init(state: ApplicationStateContract = StoriesEnvironment.shared.state) {
        self.theme = state.theme
        self.state = state

        let design = BehaviorSubject<StoriesDesignTheme>(value: self.theme)
        self.design = design
        self.output = StoriesDesign.Output(theme: design.asDriver(onErrorJustReturn: self.theme))
    }
    
    func changeToTheme(_ theme: StoriesDesignTheme) {
        self.theme = theme
        
        state.theme = theme
        design?.onNext(theme)
    }
}

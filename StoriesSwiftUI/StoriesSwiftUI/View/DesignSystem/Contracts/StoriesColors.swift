//
//  StoriesColors.swift
//  Stories
//
//
//
//

import Foundation
import SwiftUI

public protocol StoriesColors {
    func primary() -> Color
    func primaryFill() -> Color
    func secondary() -> Color
    func secondaryFill() -> Color
    func temporary() -> Color
}

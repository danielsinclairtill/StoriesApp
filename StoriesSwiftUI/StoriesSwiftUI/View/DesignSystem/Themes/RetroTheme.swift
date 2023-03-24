//
//  RetroTheme.swift
//  Stories
//
//
//

import Foundation
import SwiftUI

class RetroTheme: Theme, Attributes {
    var colors: StoriesColors = RetroTheme.StoriesColor()
    var dimensions: StoriesDimensions = RetroTheme.StoriesDimension()
    var fonts: StoriesFonts = RetroTheme.StoriesFont()

    class StoriesColor: StoriesColors {
        func primary() -> Color {
            return Color("RetroPrimary")
        }
        
        func primaryFill() -> Color {
            return Color("RetroPrimaryFill")
        }
        
        func secondary() -> Color {
            return Color("RetroSecondary")
        }
        
        func secondaryFill() -> Color {
            return Color("RetroSecondaryFill")
        }
        
        func temporary() -> Color {
            return Color("RetroTemporary")
        }
    }
    
    class StoriesFont: StoriesFonts {
        func primaryTitleLarge() -> Font {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                return .system(size: 15.0).bold()
            default:
                return .system(size: 18.0).bold()
            }
        }
        
        func primaryTitle() -> Font {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                return .system(size: 13.0).bold()
            default:
                return .system(size: 15.0).bold()
            }
        }

        func body() -> Font {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                return .system(size: 11.0)
            default:
                return .system(size: 13.0)
            }
        }
    }
    
    class StoriesDimension: StoriesDimensions {
        func coverCornerRadius() -> CGFloat {
            return 4.0
        }
        
        func tagCornerRadius() -> CGFloat {
            return 4.0
        }
    }
}

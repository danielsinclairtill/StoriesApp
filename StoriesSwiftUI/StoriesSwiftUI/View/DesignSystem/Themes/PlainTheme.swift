//
//  PlainTheme.swift
//  Stories
//
//
//
//

import Foundation
import SwiftUI

class PlainTheme: Theme, Attributes {
    var colors: StoriesColors = PlainTheme.StoriesColor()
    var dimensions: StoriesDimensions = PlainTheme.StoriesDimension()
    var fonts: StoriesFonts = PlainTheme.StoriesFont()

    class StoriesColor: StoriesColors {
        func primary() -> Color {
            return Color("PlainPrimary")
        }
        
        func primaryFill() -> Color {
            return Color("PlainPrimaryFill")
        }
        
        func secondary() -> Color {
            return Color("PlainSecondary")
        }
        
        func secondaryFill() -> Color {
            return Color("PlainSecondaryFill")
        }
        
        func temporary() -> Color {
            return Color("PlainTemporary")
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

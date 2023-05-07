//
//  PlainTheme.swift
//  Stories
//
//
//
//

import Foundation
import SwiftUI

class PlainTheme: Attributes {
    var colors: Colors = PlainTheme.PlainColors()
    var dimensions: Dimensions = PlainTheme.Dimension()
    var fonts: Fonts = PlainTheme.PlainFont()

    class PlainColors: Colors {
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
    
    class PlainFont: Fonts {
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
    
    class Dimension: Dimensions {
        func coverCornerRadius() -> CGFloat {
            return 4.0
        }
        
        func tagCornerRadius() -> CGFloat {
            return 4.0
        }
    }
}

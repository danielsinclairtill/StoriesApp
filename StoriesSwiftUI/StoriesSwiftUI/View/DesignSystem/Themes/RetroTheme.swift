//
//  RetroTheme.swift
//
//
//
//

import Foundation
import SwiftUI

class RetroTheme: Attributes {
    var colors: Colors = RetroTheme.RetroColor()
    var dimensions: Dimensions = RetroTheme.Dimension()
    var fonts: Fonts = RetroTheme.RetroFont()

    class RetroColor: Colors {
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
    
    class RetroFont: Fonts {
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

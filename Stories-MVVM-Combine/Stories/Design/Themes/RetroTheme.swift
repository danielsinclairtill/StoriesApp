//
//  RetroTheme.swift
//  Stories
//
//  Created by Daniel Till on 2023-08-22.
//

import Foundation
import UIKit

class RetroTheme: Attributes {
    let colors: Colors = RetroTheme.Color()
    let dimensions: Dimensions = RetroTheme.Dimension()
    let fonts: Fonts = RetroTheme.Font()

    // MARK: Colors
    class Color: Colors {
        func primary() -> UIColor {
            return UIColor(named: "RetroPrimary")!
        }
        
        func primaryFill() -> UIColor {
            return UIColor(named: "RetroPrimaryFill")!
        }
        
        func secondary() -> UIColor {
            return UIColor(named: "RetroSecondary")!
        }
        
        func secondaryFill() -> UIColor {
            return UIColor(named: "RetroSecondaryFill")!
        }
        
        func temporary() -> UIColor {
            return UIColor(named: "RetroTemporary")!
        }
    }
    
    // MARK: Fonts
    class Font: Fonts {
        func primaryTitleLarge() -> UIFont {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                return createDynamicFont(font: UIFont.boldSystemFont(ofSize: 15.0), style: .title1)
            default:
                return createDynamicFont(font: UIFont.boldSystemFont(ofSize: 18.0), style: .title1)
            }
        }
        
        func primaryTitle() -> UIFont {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                return createDynamicFont(font: UIFont.boldSystemFont(ofSize: 13.0), style: .title1)
            default:
                return createDynamicFont(font: UIFont.boldSystemFont(ofSize: 15.0), style: .title1)
            }
        }

        func body() -> UIFont {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                return createDynamicFont(font: UIFont.systemFont(ofSize: 11.0), style: .title2)
            default:
                return createDynamicFont(font: UIFont.systemFont(ofSize: 13.0), style: .title2)
            }
        }
        
        private func createDynamicFont(font: UIFont, style: UIFont.TextStyle) -> UIFont {
            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }
    }
    
    // MARK: Dimensions
    class Dimension: Dimensions {
        func photoCornerRadius() -> CGFloat {
            return 4.0
        }
        
        func tagCornerRadius() -> CGFloat {
            return 4.0
        }
    }
}

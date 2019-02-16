//
//  AppFonts.swift
//  
//
//  Created by Pramod Kumar on 15/12/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

enum AppFonts: String {
    
    case Light = "SourceSansPro-Light"
    case BoldItalic = "SourceSansPro-BoldItalic"
    case LightItalic = "SourceSansPro-LightItalic"
    case Regular = "SourceSansPro-Regular"
    case Italic = "SourceSansPro-Italic"
    case ExtraLight = "SourceSansPro-ExtraLight"
    case BlackItalic = "SourceSansPro-BlackItalic"
    case SemiBoldItalic = "SourceSansPro-SemiBoldItalic"
    case Bold = "SourceSansPro-Bold"
    case SemiBold = "SourceSansPro-SemiBold"
    case Black = "SourceSansPro-Black"
    case ExtraLightItalic = "SourceSansPro-ExtraLightItalic"
}

enum DeviceType {
    case iPhone5, iPhone6, iPhonePlusSize, iPadMini, iPad_10inch, iPad_12inch
}

extension AppFonts{
    
    func withSize(_ fontSize: CGFloat) -> UIFont {

        switch UIDevice.screenWidth {
            
        case let x where x < 321 :
            // For iPhone  5, 5s, 5c i.e. 320
            let iPhone5x = calculateSize(fontSize, .iPhone5)
            return UIFont(name: self.rawValue, size: iPhone5x) ?? UIFont.systemFont(ofSize: iPhone5x)
            
        case let x where x < 376 :
            //For iPhone 6:  i.e. 375
            let iPhone6x = calculateSize(fontSize, .iPhone6)
            return UIFont(name: self.rawValue, size: iPhone6x) ?? UIFont.systemFont(ofSize: iPhone6x)
            
        // For iPhone 6 Plus: i.e 414
        case let x where x < 415 :
            let iPhone6Plusx = calculateSize(fontSize, .iPhonePlusSize)
            return UIFont(name: self.rawValue, size: iPhone6Plusx) ?? UIFont.systemFont(ofSize: iPhone6Plusx)
            
        // For ipad Mini
        case let x where x < 769 :
            let iPadMini = calculateSize(fontSize, .iPadMini)
            return UIFont(name: self.rawValue, size: iPadMini) ?? UIFont.systemFont(ofSize: iPadMini)
            
        // For ipad 10 inch
        case let x where x < 835 :
            let iPad_10inch = calculateSize(fontSize, .iPad_10inch)
            return UIFont(name: self.rawValue, size: iPad_10inch) ?? UIFont.systemFont(ofSize: iPad_10inch)
            
        // For ipad 12 inch
        case let x where x < 1025 :
            let iPad_12inchx = calculateSize(fontSize, .iPad_12inch)
            return UIFont(name: self.rawValue, size: iPad_12inchx) ?? UIFont.systemFont(ofSize: iPad_12inchx)
            
        default :
            let iPadMini = calculateSize(fontSize, .iPadMini)
            return UIFont(name: self.rawValue, size: iPadMini) ?? UIFont.systemFont(ofSize: iPadMini)
        }
    }
    
    
    
//    func withDefaultSize() -> UIFont {
//        return UIFont(name: name, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
//    }
    
    
    private func calculateSize(_ fontSize:CGFloat, _ deviceType: DeviceType) -> CGFloat {
        
        switch deviceType {
        case .iPhone5:
            return fontSize * CGFloat(0.94)
        case .iPhone6:
            return fontSize
        case .iPhonePlusSize:
            return fontSize + CGFloat(2)
        case .iPadMini:
            return fontSize + fontSize * CGFloat(0.5)
        case .iPad_10inch:
            return fontSize + fontSize * CGFloat(0.6)
        case .iPad_12inch:
            return fontSize + fontSize
        }
    }
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()

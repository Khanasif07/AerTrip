//
//  AppColors.swift
//
//  Created by Pramod Kumar on 15/05/18.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit


enum AppColors {

    static let clear = UIColor.clear
    
    /// RGB - 0, 204, 153
    static let themeGreen = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1)
    
    /// RGB - 255, 144, 0
    static let themeOrange = #colorLiteral(red: 1, green: 0.5647058824, blue: 0, alpha: 1)
    
    /// RGB - 248, 185, 8
    static let themeYellow = #colorLiteral(red: 0.9725490196, green: 0.7254901961, blue: 0.03137254902, alpha: 1)
    
    /// RGB - 255, 51, 51
    static let themeRed = #colorLiteral(red: 1, green: 0.2, blue: 0.2, alpha: 1)
    
    /// RGB - 51, 153, 255
    static let themeBlue = #colorLiteral(red: 0.2, green: 0.6, blue: 1, alpha: 1)
    
    /// RGB - 0, 160, 168
    static let shadowBlue = #colorLiteral(red: 0, green: 0.6274509804, blue: 0.6588235294, alpha: 1)
    
    /// RGB - 0, 0, 0
    static let themeBlack = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    /// RGB - 102, 102, 102
    static let themeGray60 = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    /// RGB - 153, 153, 153
    static let themeGray40  = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    /// RGB - 204, 204, 204
    static let themeGray20  = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    /// RGB - 230, 230, 230
    static let themeGray10  = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    
    /// RGB - 246, 246, 246
    static let themeGray04  = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    
    /// RGB - 255, 255, 255
    static let themeWhite  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    /// RGB - 236, 253, 244
    static let themeGreenishWhite  = #colorLiteral(red: 0.9254901961, green: 0.9921568627, blue: 0.9568627451, alpha: 1)
    
    /// RGB - 51, 51, 51
    static let textFieldTextColor51  = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)

    /// RGB - 50, 58, 69
    static let themeTextColor  = #colorLiteral(red: 0.1960784314, green: 0.2274509804, blue: 0.2705882353, alpha: 1)


    case headlines
    case body
    case subheads
    case secondaryText
    case links
    case topBar
    case toolBarBackground
    case footNote
    case caption
    case divider
    case screensBackground
    case topBarBackground
    
    var color: UIColor {
        switch self {
        case .headlines, .body, .subheads:
            return AppColors.themeBlack
        
        case .secondaryText, .links :
            return AppColors.themeGray60
            
        case .topBar, .toolBarBackground :
            return AppColors.themeGray40
            
        case .footNote, .caption :
            return AppColors.themeGray20
            
        case .divider :
            return AppColors.themeGray10
            
        case .screensBackground :
            return AppColors.themeGray04
            
        case .topBarBackground :
            return AppColors.themeWhite
        }
    }
}

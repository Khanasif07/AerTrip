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
    static let themeGreen = UIColor(displayP3Red: 0, green: 0.8, blue: 0.6, alpha: 1)
    
    /// RGB - 0, 179, 134
    static let themeDarkGreen = UIColor(displayP3Red: 0, green: 0.7019607843, blue: 0.5254901961, alpha: 1)
    
    /// RGB - 1, 105, 79
    static let themeBlackGreen = UIColor(displayP3Red: 0.003921568627, green: 0.4117647059, blue: 0.3098039216, alpha: 1)
    
    /// RGB - 255, 144, 0
    static let themeOrange = UIColor(displayP3Red: 1, green: 0.5647058824, blue: 0, alpha: 1)
    
    /// RGB - 248, 185, 8
    static let themeYellow = UIColor(displayP3Red: 0.9725490196, green: 0.7254901961, blue: 0.03137254902, alpha: 1)
    
    /// RGB - 255, 51, 51
    static let themeRed = UIColor(displayP3Red: 1, green: 0.2, blue: 0.2, alpha: 1)
    
    /// RGB - 51, 153, 255
    static let themeBlue = UIColor(displayP3Red: 0.2, green: 0.6, blue: 1, alpha: 1)
    
    /// RGB - 0, 160, 168
    static let shadowBlue = UIColor(displayP3Red: 0, green: 0.6274509804, blue: 0.6588235294, alpha: 1)
    
    /// RGB - 0, 166, 128
    //static let greenTextColor = UIColor(displayP3Red: 0, green: 0.6509803922, blue: 0.5019607843, alpha: 1)
    static let themeDarkAdvisorColor = UIColor(displayP3Red: 0, green: 0.6274509804, blue: 0.5019607843, alpha: 1)
    
    
    /// RGB - 0, 0, 0
    static let themeBlack = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
    
    /// RGB - 102, 102, 102
    static let themeGray60 = UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    /// RGB - 153, 153, 153
    static let themeGray40  = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    /// RGB - 151, 151, 151
    static let themeGray151  = UIColor(displayP3Red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    
    /// RGB - 204, 204, 204
    static let themeGray20  = UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    /// RGB - 138, 138, 143, with alpha 0.22
    static let imageBackGroundColor = UIColor(displayP3Red: 0.5411764706, green: 0.5411764706, blue: 0.5607843137, alpha: 1).withAlphaComponent(0.22)
    
    /// RGB - 230, 230, 230
    static let themeGray10  = UIColor(displayP3Red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    
    /// RGB - 246, 246, 246
    static let themeGray04  = UIColor(displayP3Red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    
    /// RGB - 255, 255, 255
    static let themeWhite  = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    
    /// RGB - 236, 253, 244
    static let themeGreenishWhite  = UIColor(displayP3Red: 0.9254901961, green: 0.9921568627, blue: 0.9568627451, alpha: 1)
    
    /// RGB - 51, 51, 51
    static let textFieldTextColor51  = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    /// RGB - 66, 97, 168
    static let fbButtonBackgroundColor  = UIColor(displayP3Red: 0.2588235294, green: 0.3803921569, blue: 0.6588235294, alpha: 1)
    
    // RGB - 47, 173, 244
    static let twitterBackgroundColor  = UIColor(displayP3Red: 0.1843137255, green: 0.6784313725, blue: 0.9568627451, alpha: 1)
    
    /// RGB - 0, 120, 186
    static let linkedinButtonBackgroundColor  = UIColor(displayP3Red: 0, green: 0.4705882353, blue: 0.7294117647, alpha: 1)

    /// RGB - 50, 58, 69
    static let themeTextColor  = UIColor(displayP3Red: 0.1960784314, green: 0.2274509804, blue: 0.2705882353, alpha: 1)
    
    // RGB - 175,175,170
    static let profileImageBorderColor =  UIColor(displayP3Red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
    
    // RGB - 170 ,170 ,170
    static let noRoomsAvailableFooterColor = UIColor(displayP3Red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    
    // RGB - 212 ,217 , 216
    static let noRoomsAvailableFooterShadow = UIColor(displayP3Red: 0.831372549, green: 0.8509803922, blue: 0.8470588235, alpha: 1)
    
    // RGB - 220,220,220
    static let themeGray220 =  UIColor(displayP3Red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    
      // RGB - 0,0,0 , 0.05
    static let viewProfileDetailTopGradientColor =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.176193882)
    
    // RGB - 0,0,0, 0.0
     static let viewProfileDetailBottomGradientColor =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)

    // RGB - 126,126,126, 1.0
    static let toastBackgroundBlur = UIColor(displayP3Red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
    
    // RGB - 236,253,244, 1.0
    static let iceGreen = UIColor(displayP3Red: 0.9254901961, green: 0.9921568627, blue: 0.9568627451, alpha: 1)
    
    // RGB - 246,246,246, 1.0
    static let greyO4 = UIColor(displayP3Red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    
    // RGB - 170, 2, 255
    static let brightViolet = UIColor(displayP3Red: 0.6666666667, green: 0.007843137255, blue: 1, alpha: 1)
    
    // RGB - 24,159,166
      static let recentSeachesSearchTypeBlue = UIColor(displayP3Red: 0.09411764706, green: 0.6235294118, blue: 0.6509803922, alpha: 1)
    
    
    // RGB - 140,140,140
     static let themeGray140 = UIColor(displayP3Red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
    
    // RGB - 229,229,230
    static let blueGray = UIColor(displayP3Red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
    
    // RGB - 238,238,239
    static let unicodeBackgroundColor = UIColor(displayP3Red: 0.9333333333, green: 0.9333333333, blue: 0.937254902, alpha: 1)
    // RGB - 241,241,242
    static let quaternarySystemFillColor = UIColor(displayP3Red: 0.9450980392, green: 0.9450980392, blue: 0.9490196078, alpha: 1)

    // RGB - 228,228,229
    static let secondarySystemFillColor = UIColor(displayP3Red: 0.8941176471, green: 0.8941176471, blue: 0.8980392157, alpha: 1)

    /// RGB - 255, 255, 255
    static let themeWhite70  = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.7)
    
    /// RGB -  0 170 108
    static let reviewGreen = UIColor(displayP3Red: 0, green: 0.667, blue: 0.424, alpha: 1)
    
    /// RGB -  41 176 182
    static let dashboardGradientColor = UIColor(displayP3Red: 0.161, green: 0.690, blue: 0.714, alpha: 1)
    
    /// RGB - 230, 230, 230, 0.6
    static let themeGray10WithAlpha  = UIColor(displayP3Red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 0.6)
    
    // RGB - 0,0,0 , 0.2
    static let blackWith20PerAlpha =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
    
    static let lightYellow =  UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0)
    
    /// RGB - 255, 255, 255, 0.85
    static let themeWhite85  = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.85)

    static let greenBackground  = UIColor(displayP3Red: 146/255, green: 255/255, blue: 228/255, alpha: 1)
    
    // RGB - 0,0,0 , 0.15
    static let blackWith15PerAlpha =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.15)
    
    // RGB - 0,0,0 , 0.4
    static let blackWith40PerAlpha =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)

    
    
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

    case viewProfileTopGradient

    
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
            return AppColors.themeGray20
            
        case .screensBackground :
            return AppColors.themeGray04
            
        case .topBarBackground :
            return AppColors.themeWhite

        case .viewProfileTopGradient:
            return AppColors.themeBlack.withAlphaComponent(0.21)
        }
    }
}

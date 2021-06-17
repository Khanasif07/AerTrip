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
    static let themeGreen = UIColor(named: "themeGreen") ?? UIColor(displayP3Red: 0, green: 0.8, blue: 0.6, alpha: 1)
    
    /// RGB - 0, 204, 153 Dark RGB 0, 204, 153

    static let commonThemeGreen = UIColor(named: "commonThemeGreen") ?? UIColor(displayP3Red: 0, green: 0.8, blue: 0.6, alpha: 1)

    static let commonThemeGray = UIColor(named: "commonThemeGray") ?? UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

    static let blackAndThemeGray = UIColor(named: "blackAndThemeGray") ?? UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

    
    
    /// RGB - 0, 179, 134
    static let themeDarkGreen = UIColor(named: "themeDarkGreen") ?? UIColor(displayP3Red: 0, green: 0.7019607843, blue: 0.5254901961, alpha: 1)
    
    /// RGB - 1, 105, 79
    static let themeBlackGreen = UIColor(named: "themeBlackGreen") ?? UIColor(displayP3Red: 0.003921568627, green: 0.4117647059, blue: 0.3098039216, alpha: 1)
    
    /// RGB - 255, 144, 0
    static let themeOrange = UIColor(named: "themeOrange") ?? UIColor(displayP3Red: 1, green: 0.5647058824, blue: 0, alpha: 1)
    
    /// RGB - 248, 185, 8
    static let themeYellow = UIColor(named: "themeYellow") ?? UIColor(displayP3Red: 0.9725490196, green: 0.7254901961, blue: 0.03137254902, alpha: 1)
    
    /// RGB - 255, 51, 51,   (236, 85, 69)
    static let themeRed = UIColor(named: "themeRed") ?? UIColor(displayP3Red: 1, green: 0.2, blue: 0.2, alpha: 1)
    
    /// RGB - 51, 153, 255
    static let themeBlue = UIColor(named: "themeBlue") ?? UIColor(displayP3Red: 0.2, green: 0.6, blue: 1, alpha: 1)
    
    /// RGB - 0, 160, 168
    static let shadowBlue = UIColor(named: "shadowBlue") ?? UIColor(displayP3Red: 0, green: 0.6274509804, blue: 0.6588235294, alpha: 1)
    
    /// RGB - 0, 166, 128
    //static let greenTextColor = UIColor(displayP3Red: 0, green: 0.6509803922, blue: 0.5019607843, alpha: 1)
    static let themeDarkAdvisorColor = UIColor(named: "themeDarkAdvisorColor") ?? UIColor(displayP3Red: 0, green: 0.6274509804, blue: 0.5019607843, alpha: 1)
    
    
    /// RGB - 0, 0, 0
    static let themeBlack = UIColor(named: "themeBlack") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
    
    /// RGB - 102, 102, 102  Dark RGB 153, 153, 153
    static let themeGray60 = UIColor(named: "themeGray60") ?? UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    /// RGB - 153, 153, 153   Dark RGB 102, 102, 102
    static let themeGray40  = UIColor(named: "themeGray40") ?? UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    
    
    /// RGB - 151, 151, 151
    static let themeGray151  = UIColor(named: "themeGray151") ?? UIColor(displayP3Red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    
    /// RGB - 204, 204, 204, RGB - 79, 79,79
    static let themeGray20  = UIColor(named: "themeGray20") ?? UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    /// RGB - 214, 214, 214
    static let themeGray214  = UIColor(named: "themeGray214") ?? UIColor(displayP3Red: 0.839, green: 0.839, blue: 0.839, alpha: 1)
    
    /// RGB - 138, 138, 143, with alpha 0.22  Dark 70, 70, 70
    static let imageBackGroundColor = UIColor(named: "imageBackGroundColor") ?? UIColor(displayP3Red: 0.5411764706, green: 0.5411764706, blue: 0.5607843137, alpha: 1).withAlphaComponent(0.22)
    
    /// RGB - 230, 230, 230
    static let themeGray10  = UIColor(named: "themeGray10") ?? UIColor(displayP3Red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    
    /// RGB - 246, 246, 246 (0, 0, 0)
    static let themeGray04  = UIColor(named: "themeGray04") ?? UIColor(displayP3Red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    
    /// RGB - 249, 249, 249
    static let themeGray49  = UIColor(named: "themeGray49") ?? UIColor(displayP3Red: 0.976, green: 0.976, blue: 0.976, alpha: 1)
    
    /// RGB - 255, 255, 255
    static let themeWhite  = UIColor(named: "themeWhite") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    
    /// RGB - 236, 253, 244
    static let themeGreenishWhite  = UIColor(named: "themeGreenishWhite") ?? UIColor(displayP3Red: 0.9254901961, green: 0.9921568627, blue: 0.9568627451, alpha: 1)
    
    /// RGB - 51, 51, 51 Dark RGB 255, 255, 255
    static let textFieldTextColor51  = UIColor(named: "textFieldTextColor51") ?? UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    /// RGB - 66, 97, 16
    
    static let fbButtonBackgroundColor  = UIColor(named: "fbButtonBackgroundColor") ?? UIColor(displayP3Red: 0.2588235294, green: 0.3803921569, blue: 0.6588235294, alpha: 1)
    
    // RGB - 47, 173, 244
    static let twitterBackgroundColor  = UIColor(named: "twitterBackgroundColor") ?? UIColor(displayP3Red: 0.1843137255, green: 0.6784313725, blue: 0.9568627451, alpha: 1)
    
    /// RGB - 0, 120, 186
    static let linkedinButtonBackgroundColor  = UIColor(named: "linkedinButtonBackgroundColor") ?? UIColor(displayP3Red: 0, green: 0.4705882353, blue: 0.7294117647, alpha: 1)

    static let appleButtonBackgroundColor  = UIColor(named: "appleButtonBackgroundColor") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)

    
    /// RGB - 50, 58, 69
    static let themeTextColor  = UIColor(named: "themeTextColor") ?? UIColor(displayP3Red: 0.1960784314, green: 0.2274509804, blue: 0.2705882353, alpha: 1)
    
    // RGB - 175,175,170
    static let profileImageBorderColor =  UIColor(named: "profileImageBorderColor") ?? UIColor(displayP3Red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
    
    // RGB - 170 ,170 ,170
    static let noRoomsAvailableFooterColor = UIColor(named: "noRoomsAvailableFooterColor") ?? UIColor(displayP3Red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    
    // RGB - 212 ,217 , 216
    static let noRoomsAvailableFooterShadow = UIColor(named: "noRoomsAvailableFooterShadow") ?? UIColor(displayP3Red: 0.831372549, green: 0.8509803922, blue: 0.8470588235, alpha: 1)
    
    // RGB - 220,220,220
    static let themeGray220 =  UIColor(named: "themeGray220") ?? UIColor(displayP3Red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    
      // RGB - 0,0,0 , 0.05
    static let viewProfileDetailTopGradientColor =  UIColor(named: "viewProfileDetailTopGradientColor") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.176193882)
    
    // RGB - 0,0,0, 0.0
     static let viewProfileDetailBottomGradientColor =  UIColor(named: "viewProfileDetailBottomGradientColor") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)

    // RGB - 126,126,126, 1.0
    static let toastBackgroundBlur = UIColor(named: "toastBackgroundBlur") ?? UIColor(displayP3Red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
    
    // RGB - 236,253,244, 1.0
    static let iceGreen = UIColor(named: "iceGreen") ?? UIColor(displayP3Red: 0.9254901961, green: 0.9921568627, blue: 0.9568627451, alpha: 1)
    
    // RGB - 246,246,246, 1.0
    static let greyO4 = UIColor(named: "greyO4") ?? UIColor(displayP3Red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    
    // RGB - 170, 2, 255
    static let brightViolet = UIColor(named: "brightViolet") ?? UIColor(displayP3Red: 0.6666666667, green: 0.007843137255, blue: 1, alpha: 1)
    
    // RGB - 24,159,166
      static let recentSeachesSearchTypeBlue = UIColor(named: "recentSeachesSearchTypeBlue") ?? UIColor(displayP3Red: 0.09411764706, green: 0.6235294118, blue: 0.6509803922, alpha: 1)
    
    
    // RGB - 140,140,140
     static let themeGray140 = UIColor(named: "themeGray140") ?? UIColor(displayP3Red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
    
    // RGB - 229,229,230
    static let blueGray = UIColor(named: "blueGray") ?? UIColor(displayP3Red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
    
    // RGB - 238,238,239
    static let unicodeBackgroundColor = UIColor(named: "unicodeBackgroundColor") ?? UIColor(displayP3Red: 0.9333333333, green: 0.9333333333, blue: 0.937254902, alpha: 1)
    // RGB - 241,241,242 (255, 255, 255 0.1)
    static let quaternarySystemFillColor = UIColor(named: "quaternarySystemFillColor") ?? UIColor(displayP3Red: 0.9450980392, green: 0.9450980392, blue: 0.9490196078, alpha: 1)

    // RGB - 228,228,229
    static let secondarySystemFillColor = UIColor(named: "secondarySystemFillColor") ?? UIColor(displayP3Red: 0.8941176471, green: 0.8941176471, blue: 0.8980392157, alpha: 1)

    /// RGB - 255, 255, 255
    static let themeWhite70  = UIColor(named: "themeWhite70") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.7)
    
    /// RGB -  0 170 108
    static let reviewGreen = UIColor(named: "reviewGreen") ?? UIColor(displayP3Red: 0, green: 0.667, blue: 0.424, alpha: 1)
    
    // RGB -  41 176 182
    static let dashboardGradientColor = UIColor(named: "dashboardGradientColor") ?? UIColor(displayP3Red: 0.161, green: 0.690, blue: 0.714, alpha: 1)
    
    /// RGB - 230, 230, 230, 0.6
    static let themeGray10WithAlpha  = UIColor(named: "themeGray10WithAlpha") ?? UIColor(displayP3Red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 0.6)
    
    // RGB - 0,0,0 , 0.2 (0,0,0 , 0.2)
    static let blackWith20PerAlpha =  UIColor(named: "blackWith20PerAlpha") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
    
    // RGB - (254, 242, 199)(71, 61, 20)
    static let lightYellow =  UIColor(named: "lightYellow") ?? UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0)
    
    /// RGB - 255, 255, 255, 0.85
    static let themeWhite85  = UIColor(named: "themeWhite85") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.85)

    /// (146,255,228) (0,0,0)
    static let greenBackground  = UIColor(named: "greenBackground") ?? UIColor(displayP3Red: 146/255, green: 255/255, blue: 228/255, alpha: 1)
    
    /// (0,0,0) (146,255,228)
    static let addOnsGreenAttributed = UIColor(named: "addOnsGreenAttributed") ?? .white
    
    // RGB - 0,0,0 , 0.15
    static let blackWith15PerAlpha =  UIColor(named: "blackWith15PerAlpha") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.15)
    
    // RGB - 0,0,0 , 0.4
    static let blackWith40PerAlpha =  UIColor(named: "blackWith40PerAlpha") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
    
    // RGB - 43, 74, 244, 1.0
    static let instaButtonTopColor =  UIColor(named: "instaButtonTopColor") ?? UIColor(displayP3Red: 0.168627451, green: 0.2901960784, blue: 0.9568627451, alpha: 0.4)
    // RGB - 201, 40, 221, 1.0
    static let instaButtonMiddleColor =  UIColor(named: "instaButtonMiddleColor") ?? UIColor(displayP3Red: 0.7882352941, green: 0.1568627451, blue: 0.8666666667, alpha: 0.4)
    // RGB - 246, 19, 114, 1.0
    static let instaButtonBottomColor =  UIColor(named: "instaButtonBottomColor") ?? UIColor(displayP3Red: 0.9647058824, green: 0.07450980392, blue: 0.4470588235, alpha: 0.4)
    
    //Colors for Dashboard
    
    /// RGB - 0, 204, 153 Dark mode   RGB 19, 19, 19
    static let themeGreenDashboard = UIColor(named: "themeGreenDashboard") ?? UIColor(displayP3Red: 0, green: 0.8, blue: 0.6, alpha: 1)
    
    /// RGB - 0, 160, 168 Dark mode   RGB  37, 37, 39
    static let shadowBlueDashboard = UIColor(named: "shadowBlueDashboard") ?? UIColor(displayP3Red: 0, green: 0.6274509804, blue: 0.6588235294, alpha: 1)

    /// RGB - 255, 255, 255  Dark mode   RGB 49, 49, 49
    static let themeWhiteDashboard = UIColor(named: "themeWhiteDashboard") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    
    /// RGB - 255, 255, 255  Dark mode   RGB  255, 255, 255
    static let unicolorWhite = UIColor(named: "unicolorWhite") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    
    /// RGB - 246, 246, 246, /// RGB - 70, 70, 70
    static let themeGray04SearchBar = UIColor(named: "themeGray04SearchBar") ?? UIColor(displayP3Red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    
    static var appShadowColor: UIColor {
        return AppColors.themeBlack.withAlphaComponent(0.15)
        //return AppColors.themeRed.withAlphaComponent(0.30)
    }
    
    
    static var recentSearchColletionCellColor: UIColor = UIColor(named: "recentSearchColletionCellColor") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5)
    // (255, 255, 255) (26, 26, 26)
    static var themeBlack26: UIColor { UIColor(named: "themeBlack26") ?? .white }

    // (236, 253, 244) (24, 69, 58)
    static var calendarSelectedGreen: UIColor { UIColor(named: "calendarSelectedGreen") ?? .white }
    
    //(255, 255, 255, 0) (70, 70, 70, 1)
    static let doneViewClearColor = UIColor(named: "doneViewClearColor") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
    
    //(0, 0, 0) (0, 0, 0)
    static let themeBlackBackground = UIColor(named: "themeBlackBackground") ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    
    //(255, 255, 255, 0) (49, 49, 49, 1)
    static let selectDestinationHeaderColor = UIColor(named: "selectDestinationHeaderColor") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
    
    //(239, 242, 238)  (135, 135, 135)
    static let shimmerEffectLayerColor = UIColor(named: "shimmerEffectLayerColor") ?? UIColor(displayP3Red: 239.0/255, green: 242.0/255, blue: 238.0/255, alpha: 1)
    
    /// (clear) (49,49,49,1)
    static let flightsNavBackViewColor = UIColor(named: "flightsNavBackViewColor") ?? .white
    /// (1,105,79) (0,0,0)
    static let drawerSideColor = UIColor(named: "drawerSideColor") ?? .white
    
    ///(246,  246,  246) (26,  26,  26)
    static let singleJourneyGroupCellColor = UIColor(named: "singleJourneyGroupCellColor") ?? .white
    
    /// RGB - (102, 102, 102)  (102, 102, 102)
    static let flightCellDashColor = UIColor(named: "flightCellDashColor") ?? UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    /// RGB - (102, 102, 102)  (255, 255, 255)
    static let grayWhite = UIColor(named: "grayWhite") ?? UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    
    /// RGB - 255, 144, 0
    static let cheapestPriceColor = UIColor(named: "cheapestPriceColor") ?? UIColor(displayP3Red: 1, green: 0.5647058824, blue: 0, alpha: 1)
    
    /// RGB - 153, 153, 153   Dark RGB 153, 153, 153
    static let themeGray153  = UIColor(named: "themeGray153") ?? UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    /// RGB - (0, 204, 153 , 0.1) (0, 204, 153 , 0.2)
    static let groupCellSelectedTimeColor  = UIColor(named: "groupCellSelectedTimeColor") ?? UIColor(displayP3Red: 0, green: 0.8, blue: 0.6, alpha: 0.1)
    
    //(66, 66, 66) (255, 255, 255)
    static let muticityAddRemoveTextColor  = UIColor(named: "muticityAddRemoveTextColor") ?? UIColor(displayP3Red: 66.0/255, green: 66.0/255, blue: 66.0/255, alpha: 1)

    ///(230,230,230) (49,49,49)
    static let switchGray = UIColor(named: "switchGray") ?? .white
    
    ///(230, 230, 230) (120, 120, 120)
    static let flightFormReturnDisableColor = UIColor(named: "flightFormReturnDisableColor") ?? UIColor(displayP3Red: 66.0/255, green: 66.0/255, blue: 66.0/255, alpha: 1)
    
    ///(153, 153, 153) (255, 255, 255)
    static let flightFormReturnEnableColor = UIColor(named: "flightFormReturnEnableColor") ?? UIColor(displayP3Red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    
    ///(255, 255, 255) (26, 26, 26)
    static let flightResultsFooterSecondaryColor = UIColor(named: "flightResultsFooterSecondaryColor") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    
    ///(255, 255, 255) (10, 10, 10)
    static let flightResultsFooterThirdColor = UIColor(named: "flightResultsFooterThirdColor") ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    
    /// RGB - 204, 204, 204,   (255, 255, 255, 0.2)
    static let dividerColor = UIColor(named: "dividerColor") ?? UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    //(230, 230, 230) (255, 255, 255, 0.2)
    static let sliderTrackColor = UIColor(named: "sliderTrackColor") ?? UIColor(displayP3Red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    
    
    // (236, 253, 244) (0, 204, 153, 0.2)
    static var flightFilterSessionSelectedColor: UIColor { UIColor(named: "flightFilterSessionSelectedColor") ?? .white }
    
    ///(246,  246,  246) (255, 255, 255,  0.1)
    static var flightFilterSessionDefaultColor: UIColor { UIColor(named: "flightFilterSessionDefaultColor") ?? .white }
    
    ///(230,230,230) (255, 255, 255,  0.1)
    static var flightFilterHighlightColor: UIColor { UIColor(named: "flightFilterHighlightColor") ?? .white }
    

    ///(236,253,244,0.5) (47,53,52)
    static var stopsAllDeselected: UIColor { UIColor(named: "stopsAllDeselected") ?? .white } 

    //(0, 0, 0) (153, 153, 153)
    static let baggageTypeTitleColor:UIColor = UIColor(named: "baggageTypeTitleColor") ?? AppColors.themeBlack
    
    
    //(238, 204, 78) (255, 255, 255, 0.1)
    static let fewSeatLeftColor :UIColor = UIColor(named: "fewSeatLeftColor") ?? AppColors.themeBlack
  

    //(238, 204, 78) (255, 255, 255, 0.1)
//    static let fewSeatLeftColor :UIColor = UIColor(named: "fewSeatLeftColor") ?? AppColors.themeBlack
    
    static let upgradeFlightIndicator: UIColor = UIColor(named: "upgradeFlightIndicator") ?? AppColors.unicolorWhite
    

    //(216,216,216) (70,70,70)
    static let performanceBackColor: UIColor = UIColor(named: "performanceBackColor") ?? .white

    //(153,153,153) (120,120,120)
    static let flightFormGray: UIColor = UIColor(named: "flightFormGray") ?? .white
    
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
            return AppColors.dividerColor//AppColors.themeGray20
            
        case .screensBackground :
            return AppColors.themeGray04
            
        case .topBarBackground :
            return AppColors.themeWhite

        case .viewProfileTopGradient:
            return AppColors.themeBlack.withAlphaComponent(0.21)
        }
    }
}

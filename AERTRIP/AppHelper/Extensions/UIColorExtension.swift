//
//  UIColorExtension.swift
//
//  Created by Pramod Kumar on 19/09/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//


//import Foundation
import UIKit

extension UIColor{
    
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
    
    convenience init(r: Int, g: Int, b: Int, alpha : CGFloat) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 1, "Invalid alpha component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    ///Returns the color based on the given R,G,B and alpha values
    class func colorRGB(r:Int, g:Int, b:Int, alpha:CGFloat = 1)->UIColor{
        
        return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    ///Returns the color based on the given hex string
    class func colorHex(hexString:String) -> UIColor {
        
        var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            
            cString = cString.substring(with: (cString.index(cString.startIndex, offsetBy: 1) ..< cString.endIndex))
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

// FLIGHTS

extension UIColor {
    
    @objc static var themeBlack : UIColor { AppColors.themeBlack } //{ return UIColor(red: 0/255.0 , green:0/255.0 , blue:0/255.0 , alpha:1) }
    
    @objc static var appColor : UIColor { AppColors.themeGreen } //{ return UIColor(red: 0/255.0 , green:204/255.0 , blue:153/255.0 , alpha:1) }
    
    @objc static var OffWhiteColor : UIColor {AppColors.themeGray04} //{ return UIColor(red: 246/255.0 , green:246/255.0 , blue:246/255.0 , alpha:1) }
    
    @objc static var AertripColor : UIColor { AppColors.themeGreen } //{ return UIColor(red: 0/255.0 , green:204/255.0 , blue:153/255.0 , alpha:1) }
    
    @objc static var GREEN_BLUE_COLOR : UIColor { AppColors.themeGreen } //{ return UIColor(displayP3Red: 0 , green:204/255.0 , blue:153/255.0 , alpha:1) }
    
    @objc static var BLUE_GREEN_COLOR : UIColor { AppColors.dashboardGradientColor } //{ return UIColor(red: 41/255.0 , green:176/255.0 , blue:182/255.0 , alpha:1) }
    
    @objc static var ONE_ZORE_TWO_COLOR : UIColor { AppColors.themeGray60 } //{ return UIColor(red: 102/255.0 , green:102/255.0 , blue:102/255.0 , alpha:1) }
    
    @objc static var ONE_FIVE_THREE_COLOR : UIColor { AppColors.themeGray40 } //{ return UIColor(red: 153/255.0 , green:153/255.0 , blue:153/255.0 , alpha:1) }
    
    @objc static var WHITE_COLOR : UIColor  { AppColors.themeWhite } //{ return UIColor(red: 255/255.0 , green:255/255.0 , blue:255/255.0 , alpha:1) }
    
    @objc static var FB_COLOR : UIColor {AppColors.fbButtonBackgroundColor} //{ return UIColor(red: 66/255.0 , green:97/255.0 , blue:168/255.0 , alpha:1) }
    
    @objc static var AppColorCustom : UIColor { AppColors.themeDarkGreen } //{ return UIColor(red: 0/255.0 , green:179/255.0 , blue:134/255.0 , alpha:1) }
    
    @objc static var FIVE_ONE_COLOR : UIColor { AppColors.textFieldTextColor51 } //{ return UIColor(red: 51/255.0 , green:51/255.0 , blue:51/255.0 , alpha:1) }
    
    @objc static var BUTTON_DISABLED_START_COLOR : UIColor { AppColors.noRoomsAvailableFooterColor } //{ return UIColor(red: 170/255.0 , green:170/255.0 , blue:170/255.0 , alpha:1) }
    
    @objc static var TWO_ZERO_FOUR_COLOR : UIColor { AppColors.themeGray20 } //{ return UIColor(red: 204/255.0 , green:204/255.0 , blue:204/255.0 , alpha:1) }
    
//    @objc static var ONE_FOUR_TWO_COLOR : UIColor  { return UIColor(red: 142/255.0 , green:142/255.0 , blue:147/255.0 , alpha:1) } ///Never used
    
    @objc static var SELECTION_COLOR : UIColor { AppColors.themeGreenishWhite } //{ return UIColor(red: 236/255.0 , green:253/255.0 , blue:244/255.0 , alpha:1) }
    
    @objc static var TWO_THREE_ZERO_COLOR : UIColor  { AppColors.themeGray10 } //{ return UIColor(red: 230/255.0 , green:230/255.0 , blue:230/255.0 , alpha:1) }
    
    @objc static var AERTRIP_RED_COLOR : UIColor  { AppColors.themeRed } //{ return UIColor(red: 255.0/255.0 , green:51/255.0 , blue:51/255.0 , alpha:1) }
    
    @objc static var AERTRIP_ORAGE_COLOR : UIColor  { AppColors.cheapestPriceColor } //{ return UIColor(red: 255.0/255.0 , green:144.0/255.0 , blue:0.0 , alpha:1) }
    
    @objc static var AERTRIP_BLUE_COLOR : UIColor  { AppColors.themeBlue } //{ return UIColor(red: 51.0/255.0 , green:153.0/255.0 , blue:255.0/255.0 , alpha:1) }
    
//    @objc static var PIN_RED_COLOR : UIColor { return UIColor(displayP3Red: (253.0/255.0), green: (191.0/255.0), blue: (192.0/255.0), alpha: 1.0) } ///Never used
    
    @objc static var appShadow : UIColor{return AppColors.appShadowColor}
    
    
    @objc static var themeWhiteDashboard : UIColor{return AppColors.themeWhiteDashboard}
    
    @objc static var themeBlack26: UIColor { AppColors.themeBlack26 }
    
    @objc static var calendarSelectedGreen: UIColor { AppColors.calendarSelectedGreen }
    
    @objc static var themeGray60: UIColor { AppColors.themeGray60 }
    
    @objc static var doneViewClearColor: UIColor {AppColors.doneViewClearColor}
    
    @objc static var muticityAddRemoveTextColor:UIColor { AppColors.muticityAddRemoveTextColor }
    
    @objc static var flightFormReturnDisableColor:UIColor { AppColors.flightFormReturnDisableColor }
    
    @objc static var flightFormReturnEnableColor:UIColor { AppColors.flightFormReturnEnableColor }
}

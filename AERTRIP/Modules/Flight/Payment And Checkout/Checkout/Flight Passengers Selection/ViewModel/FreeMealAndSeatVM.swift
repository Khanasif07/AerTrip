//
//  FreeMealAndSeatVM.swift
//  Aertrip
//
//  Created by Apple  on 19.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation


enum FreeServiveType{
    case meal, seat, both
}
class FreeMealAndSeatVM{
    
    var freeServiceType:FreeServiveType = .both
    var title:NSAttributedString?
    
    init() {
        switch freeServiceType{
        case .meal:
            let str = "You’ve just earned a Free Meal allocation for this booking."
            let titleString = NSMutableAttributedString(string: str, attributes: [.foregroundColor: AppColors.themeBlack, .font: AppFonts.Regular.withSize(16)])
            let range = NSString(string: str).range(of: "Free Meal")
            titleString.addAttribute(.font, value: AppFonts.SemiBold.withSize(16), range: range)
            self.title = titleString
        case .seat:
            let str = "You’ve just earned a Free Seat allocation for this booking."
            let titleString = NSMutableAttributedString(string: str, attributes: [.foregroundColor: AppColors.themeBlack, .font: AppFonts.Regular.withSize(16)])
            let range = NSString(string: str).range(of: "Free Seat")
            titleString.addAttribute(.font, value: AppFonts.SemiBold.withSize(16), range: range)
            self.title = titleString
        case .both:
            let str = "You’ve just earned a Free Meal and Free Seat allocation for this booking."
            let titleString = NSMutableAttributedString(string: str, attributes: [.foregroundColor: AppColors.themeBlack, .font: AppFonts.Regular.withSize(16)])
            let range = NSString(string: str).range(of: "Free Meal")
            let range1 = NSString(string: str).range(of: "Free Seat")
            titleString.addAttribute(.font, value: AppFonts.SemiBold.withSize(16), range: range)
            titleString.addAttribute(.font, value: AppFonts.SemiBold.withSize(16), range: range1)
            self.title = titleString
        }
        
    }
    //"You’ve just earned a Free Meal and Free Seat allocation for this booking."
    
}

//
//  AdonsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AdonsVM  {

    enum AdonsType : Int  {
        case meals = 0
        case baggage
        case seat
        case otheres
    }
    
    let adOnsTitles = [LocalizedString.Meals.localized, LocalizedString.Baggage.localized, LocalizedString.Seat.localized, LocalizedString.Others.localized]
    
    let addOnsData : [(heading : String,desc : String,complement : String, shouldShowComp : Bool)] = [( LocalizedString.Meals.localized, "Choose a meal from the menu.","Complementary meal added Complementary meal added",true), ( LocalizedString.Baggage.localized, "Choose the extra baggage service and take everything you need Choose the extra baggage service and take everything you need Choose the extra baggage service and take everything you need.","Complementary meal added",false),( LocalizedString.Seat.localized, "Reserve a seat of your choice.","Free Seats Available",true),( LocalizedString.Others.localized, "Pre-book more services for a  convenient journey","Complementary meal added",false)]
    
    var itineraryData = FlightItineraryData()

    
    func getCellHeight(index : Int) -> CGFloat {
        
            let labelWidth = UIScreen.main.bounds.width - (16 + 104 + 19 + 46)
                    
             let headingHeight = addOnsData[index].heading.getTextHeight(width: labelWidth,font: AppFonts.SemiBold.withSize(18),  numberOfLines: 1)
                     
             let descHeight = addOnsData[index].desc.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(14),  numberOfLines: 2)

             let complementHeight = addOnsData[index].complement.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(12),  numberOfLines: 1) + 4
        
             let complementHeightToBeAddedOrNot : CGFloat = addOnsData[index].shouldShowComp ? complementHeight : 0

             let midSpacing : CGFloat = 7
             
             let topAndBottomSpacing : CGFloat = 19 + 19
             
             let totalHeight = headingHeight + descHeight + complementHeightToBeAddedOrNot + midSpacing + topAndBottomSpacing
             
             let finalheight = totalHeight <= 104 ? 104 : totalHeight
        
        return finalheight
    }
    
    
}

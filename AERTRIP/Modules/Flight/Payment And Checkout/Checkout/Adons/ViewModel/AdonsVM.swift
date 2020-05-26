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
    
}

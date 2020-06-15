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
    
    struct AddonsData{
        let heading : String
        var description : String
        var complementString : String
        var shouldShowComp : Bool
        let addonsType : AdonsType
        
        init(type : AdonsType, heading : String, description : String, complementString : String, shouldShowComp : Bool){
            self.addonsType = type
            self.heading = heading
            self.description = description
            self.complementString = complementString
            self.shouldShowComp = shouldShowComp
        }
        
    }
    
    let adOnsTitles = [LocalizedString.Meals.localized, LocalizedString.Baggage.localized, LocalizedString.Seat.localized, LocalizedString.Others.localized]
    
   // let addOnsData : [(heading : String,desc : String,complement : String, shouldShowComp : Bool)] = [( LocalizedString.Meals.localized, "Choose a meal from the menu.","Complementary meal added Complementary meal added",true), ( LocalizedString.Baggage.localized, "Choose the extra baggage service and take everything you need Choose the extra baggage service and take everything you need Choose the extra baggage service and take everything you need.","Complementary meal added",false),( LocalizedString.Seat.localized, "Reserve a seat of your choice.","Free Seats Available",true),( LocalizedString.Others.localized, "Pre-book more services for a  convenient journey","Complementary meal added",false)]
    
//    var itineraryData = FlightItineraryData()

    var addonsData : [AddonsData] = []
    
    func setAdonsOptions(){
        
        let flightsWithData = AddonsDataStore.shared.flightsWithData
        
           let flightsWithMeals = flightsWithData.filter { !$0.meal.addonsArray.isEmpty }
           let flightsWithBaggage = flightsWithData.filter {!$0.bags.addonsArray.isEmpty }
           let flightsWithOthers = flightsWithData.filter {!$0.special.addonsArray.isEmpty }

        if !flightsWithMeals.isEmpty{
            addonsData.append(AdonsVM.AddonsData(type: .meals, heading: LocalizedString.Meals.localized, description: LocalizedString.Choose_Meal.localized, complementString: "", shouldShowComp: false))
        }
           
        if !flightsWithBaggage.isEmpty{
            addonsData.append(AdonsVM.AddonsData(type: .baggage, heading: LocalizedString.Baggage.localized, description: LocalizedString.Choose_Baggage.localized, complementString: "", shouldShowComp: false))
        }
        
        addonsData.append(AdonsVM.AddonsData(type: .seat, heading: LocalizedString.Seat.localized, description: LocalizedString.Reserve_Seat.localized, complementString: "", shouldShowComp: false))

        if !flightsWithOthers.isEmpty{
            addonsData.append(AdonsVM.AddonsData(type: .otheres, heading: LocalizedString.Other.localized, description: LocalizedString.PreBook_Services.localized, complementString: "", shouldShowComp: false))
         }
       }
    
    func getCellHeight(index : Int) -> CGFloat {
        
            let labelWidth = UIScreen.main.bounds.width - (16 + 104 + 19 + 46)
                    
             let headingHeight = addonsData[index].heading.getTextHeight(width: labelWidth,font: AppFonts.SemiBold.withSize(18),  numberOfLines: 1)
                     
             let descHeight = addonsData[index].description.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(14),  numberOfLines: 2)

             let complementHeight = addonsData[index].complementString.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(12),  numberOfLines: 1) + 4
        
             let complementHeightToBeAddedOrNot : CGFloat = addonsData[index].shouldShowComp ? complementHeight : 0

             let midSpacing : CGFloat = 7
             
             let topAndBottomSpacing : CGFloat = 19 + 19
             
             let totalHeight = headingHeight + descHeight + complementHeightToBeAddedOrNot + midSpacing + topAndBottomSpacing
             
             let finalheight = totalHeight <= 104 ? 104 : totalHeight
        
        return finalheight
    }
    
    func getSeatMapContainerVM() -> SeatMapContainerVM {
        
        let viewModel = SeatMapContainerVM(AddonsDataStore.shared.itinerary.sid, AddonsDataStore.shared.itinerary.id, AddonsDataStore.shared.itinerary.details.fk)
        return viewModel
    }
}

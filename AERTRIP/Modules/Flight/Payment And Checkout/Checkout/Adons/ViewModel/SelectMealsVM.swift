//
//  SelectMealsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SelectMealVmDelegate : class {

    func contactAddedToMeal()
    
}

class SelectMealsVM {
    
    var vcIndex : Int = 0
    var itinerary = FlightItinerary()
    var adons : [String : AddonsData] = [:]

    var currentFlightKey : String = ""
    var currentAdonsData = AddonsData()

    weak var delegate : SelectMealVmDelegate?
    
    var flightKeys : [String] {
        return  Array(adons.keys)
    }
        
    func extractUsefullData() {
        guard let adon = itinerary.details.addons else{
              return
            }
        adons = adon
        currentFlightKey = flightKeys[vcIndex]
        currentAdonsData = adons[flightKeys[vcIndex]] ?? AddonsData()
    }
    
    func updateContactInMeal(currentFlightKey: String, mealIndex: Int, contacts : [ATContact]){
        
        self.currentAdonsData.meal[mealIndex].selectedFor = contacts
        
        
        self.delegate?.contactAddedToMeal()
        
    }
    
}

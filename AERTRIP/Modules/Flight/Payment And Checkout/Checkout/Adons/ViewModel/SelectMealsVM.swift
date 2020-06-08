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
    var currentFlightKey : String = ""

//    var itinerary = FlightItinerary()
//    var adons : [String : AddonsData] = [:]
//
//    var currentAdonsData = AddonsData()
//
    weak var delegate : SelectMealVmDelegate?
//
//    var flightKeys : [String] {
//        return  Array(adons.keys)
//    }
//
//    func extractUsefullData() {
//        guard let adon = itinerary.details.addons else{
//              return
//            }
//        adons = adon
//        currentFlightKey = flightKeys[vcIndex]
//        currentAdonsData = adons[flightKeys[vcIndex]] ?? AddonsData()
//    }
    
    init(){
        
    }
    
    init(vcIndex : Int, currentFlightKey : String){
        self.vcIndex = vcIndex
        self.currentFlightKey = currentFlightKey
    }
    
    
    func getMealsDataForCurrentFlight() -> [Addons] {
        guard let keyData = AddonsDataStore.shared.adons[self.currentFlightKey] else { return [] }
        return keyData.meal
    }
    
//    func updateContactInMeal(currentFlightKey: String, mealIndex: Int, contacts : [ATContact]){
//    AddonsDataStore.shared.adons[currentFlightKey]?.meal[mealIndex].mealsSelectedFor = contacts
//        self.delegate?.contactAddedToMeal()
//
//    }
    
    
    
}

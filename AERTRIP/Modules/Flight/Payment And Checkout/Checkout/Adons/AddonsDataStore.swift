//
//  AddonsDataStore.swift
//  AERTRIP
//
//  Created by Appinventiv on 03/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class AddonsDataStore {
    
     static let shared = AddonsDataStore()
    
     var itinerary = FlightItinerary()
     var adons : [String : AddonsData] = [:]
//     var allFlightKeys : [String] {
//         return  Array(adons.keys)
//     }
     var allFlights : [IntFlightDetail] = []
    
    
     var addonsMaster = AddonsMaster()
     var addonsLeg = AddonsLeg()
     var flightsWithData :[AddonsFlight] = []
     var flightKeys : [String] = []
    
    
    init(){
        
    }
    
    init(itinerary : FlightItinerary){
        
    }
    
    func initialiseItinerary(itinerary : FlightItinerary, addonsMaster : AddonsMaster){
        self.itinerary = itinerary
        self.addonsMaster = addonsMaster
        self.extractUsefullData()
    }
    
     func extractUsefullData() {
        
        guard let adon = itinerary.details.addons else{
             return }
    
        adons = adon
        
        allFlights = itinerary.details.legsWithDetail.flatMap {
               return $0.flightsWithDetails
         }
        
        flightsWithData = addonsMaster.legs.flatMap {
            return $0.value.flight
        }
        
        flightKeys = flightsWithData.map { (flights) -> String in
            return flights.flightId
        }
        
     }
    
    
    func setContactsForMeal(vcIndex: Int, currentFlightKey: String, mealIndex: Int, contacts : [ATContact]){
        guard var keyData = adons[currentFlightKey] else { return }
        keyData.meal[mealIndex].mealsSelectedFor = contacts
        adons[currentFlightKey]? = keyData
    }
    
    func setContactsForBaggage(vcIndex: Int, currentFlightKey: String, baggageIndex: Int, contacts : [ATContact]){
        guard var keyData = adons[currentFlightKey] else { return }
        keyData.baggage[baggageIndex].bagageSelectedFor = contacts
        adons[currentFlightKey]? = keyData
    }
    
}


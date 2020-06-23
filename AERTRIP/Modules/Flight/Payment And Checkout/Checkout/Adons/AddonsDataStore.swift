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

     var allFlights : [IntFlightDetail] = []
     var addonsMaster = AddonsMaster()
    // var addonsLeg = AddonsLeg()
     var flightsWithData :[AddonsFlight] = []
     var flightKeys : [String] = []
    
    var appliedCouponData = FlightItineraryData()
    var taxesResult:[String:String] = [:]
    var passengers = [ATContact]()
    var gstDetail = GSTINModel()
    var email = ""
    var mobile = ""
    var isd = ""
    var isGSTOn = false
    
    var seatsArray = [SeatMapModel.SeatMapRow]()
    var originalSeatMapModel: SeatMapModel?
    var seatsAllFlightsData: [SeatMapModel.SeatMapFlight]?
    
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
//
//        guard let adon = itinerary.details.addons else{
//             return }
//
//        adons = adon
        
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
        
    func getMealsSelectionCount() -> Int {
        
        self.flightsWithData.forEach { (addon) in
            
        }
        
        return 0
    }
    
    func resetData() {
        seatsArray.removeAll()
        originalSeatMapModel = nil
        seatsAllFlightsData = nil
    }
    
}

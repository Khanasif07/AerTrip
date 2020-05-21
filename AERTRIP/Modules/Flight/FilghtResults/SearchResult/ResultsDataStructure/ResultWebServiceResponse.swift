//
//  ResultWebServiceResponse.swift
//  Aertrip
//
//  Created by  hrishikesh on 14/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//


import UIKit


public struct FlightSearchWSResponse : Codable {
    var data : FlightSearchResponseData?
}


public struct FlightSearchResponseData : Codable {
    let sid : String?
    var completed : Int?
    var flights : [Flights]?
    let done : Bool?
}


public struct Flights : Codable {
    var results : FlightsResults
    var vcode : String
}

public struct  FlightsResults : Codable {
    var j : [Journey]
    var f : [FiltersWS]
    var apdet : [String : AirportDetailsWS]
    var taxes : [String : String]
    var aldet : [String : String]
    var alMaster :[ String :AirlineMasterWS]
    
    
    init() {
        j = [Journey]()
        f = [FiltersWS]()
        apdet =  [String : AirportDetailsWS]()
        taxes = [String : String]()
        aldet = [String : String]()
        alMaster = [ String :AirlineMasterWS]()
    }
    
    
    func setAirlinesToJourney (_ journey : [Journey] ,  airlineMasterTable : [ String :AirlineMasterWS] ) -> [Journey] {
        
        let modifiedJourneyArray = journey.map({ (journey) -> Journey in
            let newJourney = journey
            let airlineArray = journey.al
            
            switch airlineArray.count {
            case 1 :
                let airlineCode = airlineArray[0]
                let airlineName = airlineMasterTable[airlineCode]?.name
                newJourney.airlinesSubString = airlineName
            default :
                newJourney.airlinesSubString = String(airlineArray.count) + " Carriers"
            }
            
            var logoArray = [String]()
            for airline in airlineArray {
                let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + airline.uppercased() + ".png"
                logoArray.append(logoURL)
            }
            newJourney.airlineLogoArray = logoArray
            return newJourney
        })
        
        return modifiedJourneyArray
        
    }
}

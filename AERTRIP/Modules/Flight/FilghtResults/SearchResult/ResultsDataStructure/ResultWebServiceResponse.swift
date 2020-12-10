//
//  ResultWebServiceResponse.swift
//  Aertrip
//
//  Created by  hrishikesh on 14/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//


import UIKit


public struct FlightSearchWSResponse {
    var data : FlightSearchResponseData?
    
    init(json: JSON) {
        data = FlightSearchResponseData(json: json["data"])
    }
}


public struct FlightSearchResponseData {
    let sid : String?
    var completed : Int?
    var flights : [Flights]?
    let done : Bool?
    
    init(json: JSON) {
        sid = json["sid"].string
        completed = json["completed"].int
        flights = json["flights"].arrayValue.map { Flights(json: $0) }
        done = json["done"].bool
    }
}


public struct Flights {
    var results : FlightsResults
    var vcode : String
    
    init(json: JSON) {
        results = FlightsResults(json: json["results"])
        vcode = json["vcode"].stringValue
    }
}

public struct  FlightsResults {
    var j : [Journey]
    var f : [FiltersWS]
    var apdet : [String : AirportDetailsWS]
    var taxes : [String : String]
    var aldet : [String : String]
    var alMaster :[ String :AirlineMasterWS]
    var taxSort : String
    var eqMaster : [String: IntMultiCityAndReturnWSResponse.Results.EqMaster]
    
    init() {
        j = [Journey]()
        f = [FiltersWS]()
        apdet =  [String : AirportDetailsWS]()
        taxes = [String : String]()
        aldet = [String : String]()
        alMaster = [ String :AirlineMasterWS]()
        taxSort = ""
        eqMaster = [:]
    }
    
    init(json: JSON) {
        j = json["j"].arrayValue.map { Journey(json: $0) }
        f = json["f"].arrayValue.map { FiltersWS(json: $0) }
        apdet = Dictionary(uniqueKeysWithValues: json["apdet"].map { ($0.0, AirportDetailsWS(json: $0.1)) })
        taxes = Dictionary(uniqueKeysWithValues: json["taxes"].map { ($0.0, $0.1.stringValue) })
        aldet = Dictionary(uniqueKeysWithValues: json["aldet"].map { ($0.0, $0.1.stringValue) })
        alMaster = Dictionary(uniqueKeysWithValues: json["alMaster"].map { ($0.0, AirlineMasterWS(json: $0.1)) })
        taxSort = json["taxSort"].stringValue
        eqMaster = Dictionary(uniqueKeysWithValues: json["eqMaster"].map { ($0.0, IntMultiCityAndReturnWSResponse.Results.EqMaster($0.1)) })
    }
    
    func setAirlinesToJourney (_ journey : [Journey] ,  airlineMasterTable : [ String :AirlineMasterWS] ) -> [Journey] {
        
        let modifiedJourneyArray = journey.map({ (journey) -> Journey in
            let newJourney = journey
            let airlineArray = journey.al
            
//            printDebug("airlineArray...\(airlineArray)")
            
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


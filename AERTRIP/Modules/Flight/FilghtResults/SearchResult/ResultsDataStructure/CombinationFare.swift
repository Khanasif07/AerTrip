//
//  CombinationFare.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 24/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation


public struct ComboFlightSearchWSResponse  {
    var data : ComboResponseData?
    
    init(json : JSON){
        
        data = ComboResponseData(json: json["data"])
        
    }
    
}


public struct ComboResponseData  {
    let sid : String?
    var completed : Int?
    var flights : [ComboFlights]?
    let done : Bool?
    
    init(json : JSON){

        sid = json["sid"].stringValue
        completed = json["completed"].intValue
        flights = json["flights"].arrayValue.map( { ComboFlights(json: $0) } )
        done = json["done"].boolValue
        
    }
    
}

public struct ComboFlights  {
    
    var results : ComboFlightsResults
    var vcode : String
    
    init(json : JSON){
        results = ComboFlightsResults(json: json["json"])
        vcode = json["vcode"].stringValue
    }
    
}

public struct  ComboFlightsResults {
    
    var c : [CombinationJourney]
    var apdet : [String : AirportDetailsWS]
    var taxes : [String : String]
    var aldet : [String : String]
    var alMaster :[ String :AirlineMasterWS]
    var taxSort : String
    
    
    init() {
        c = [CombinationJourney]()
        apdet =  [String : AirportDetailsWS]()
        taxes = [String : String]()
        aldet = [String : String]()
        alMaster = [ String :AirlineMasterWS]()
        taxSort = ""
    }
    
    init(json : JSON) {
        
        c = json["c"].arrayValue.map( { CombinationJourney(json: $0) } )
        
        apdet = Dictionary(uniqueKeysWithValues: json["apdet"].map { ($0.0, AirportDetailsWS(json: $0.1)) })
        
        taxes = Dictionary(uniqueKeysWithValues: json["taxes"].map { ($0.0, $0.1.stringValue) })
        
        aldet = Dictionary(uniqueKeysWithValues: json["aldet"].map { ($0.0, $0.1.stringValue) })

        alMaster = Dictionary(uniqueKeysWithValues: json["alMaster"].map { ($0.0, AirlineMasterWS(json: $0.1)) })

        taxSort = json["taxSort"].stringValue
        
    }
    
}


public class CombinationJourney {
   
    let vendor : String
    let id : String
    let fk : [String]
    let ofk : String?
    let otherfares : Bool?
    let farepr : Int
    let iic : Bool
    let displaySeat : Bool
    var fare : Taxes
    

    init(json : JSON){

        vendor = json["vendor"].stringValue
        id = json["id"].stringValue
        fk = json["fk"].arrayValue.map { $0.stringValue }
        ofk = json["ofk"].stringValue
        otherfares = json["otherfares"].boolValue
        farepr = json["farepr"].intValue
        iic = json["iic"].boolValue
        displaySeat = json["displaySeat"].boolValue
        fare = Taxes(json: json["fare"])
        
    }
    
    

}

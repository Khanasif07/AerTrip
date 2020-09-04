//
//  CombinationFare.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 24/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation



public struct ComboFlightSearchWSResponse : Codable {
    var data : ComboResponseData?
}


public struct ComboResponseData : Codable {
    let sid : String?
    var completed : Int?
    var flights : [ComboFlights]?
    let done : Bool?
}

public struct ComboFlights : Codable {
    var results : ComboFlightsResults
    var vcode : String
}

public struct  ComboFlightsResults : Codable {
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
    
}


public class CombinationJourney: Codable {
    let vendor : String
    let id : String
    let fk : [String]
    let ofk : String?
    //    let invfk : Bool
    //    let pricingsolutionKey: String
    let otherfares : Bool?
    let farepr : Int
    let iic : Bool
    let displaySeat : Bool
    var fare : Taxes
    
//    let rfd : Int
//    let rsc : Int
//    let dt : String
//    let at : String
//    let tt : [Int]
//    // slo : Short Layover
//    let slo  : Int
//    let slot : String
//    //llow : Long layover
//    let llow : Int
//    let llowt : String
//    let red : Int
//    let redt : String
//    let cot : Int
//    let cop : Int
//    let copt : String
//    // FSR : Few Seats remaining
//    let fsr : Int
//    let seats : String?
//    let al : [String]
//    let stp : String
//    let ap : [String]
//    let loap : [String]
//    //    let load : []
//    let leg : [FlightLeg]
//    let isLcc : Int
    //    let hmnePrms :
    //    let apc :
//    let sict : Bool?
    //    let fareBasis
    //    let coat :
//    let dspNoshow : Int
    //    let rfdPlcy
    //    let qid :
//    let cc : String
    //    let eqt : Int
    // Fcc : Change of flight class. If flight is not available in seach class different / lower class flights is displayed
//    let fcc : String?
//    // lg = luggage , if lg == 1 lugguage is allowed  if lg == 0 luggauge is not allowed
//    let lg : Int
//    let ovngt : Int
//    let ovngtt : String
//    let ovgtf : Int
//    let ovgtlo : Int
//    let dd : String
//    let ad : String
//    let coa : Int
//    let humaneScore : Float
//    //    let humaneArr
//    let humanePrice : Humanprice
    
    

}

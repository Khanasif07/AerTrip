//
//  Structures.swift
//  Aertrip
//
//  Created by  hrishikesh on 29/05/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation
import UIKit

public struct FiltersWS : Codable {
   
    var multiAl : Int?
    var cityapN : cityWiseAirportCode
    var fares : [ String]
    var fq : [String : String]
    var pr  : priceWS
    var stp  : [String]
    var al :  [String]
    var depDt  : DateTime
    var arDt : DateTime
    var dt : TimeRange24hoursWS
    var at : TimeRange24hoursWS
    var tt :TimeRangeIntervalWS
    var loap : [String]
    var lott : TimeRangeIntervalWS?
    var originTz : TimeRangeTimeZone
    var destinationTz :TimeRangeTimeZone
    var ap : [String]
    var cityap : [String : [String]]
    
    
    init(json : JSON){
        
        multiAl = json["multiAl"].intValue
        cityapN  = cityWiseAirportCode(json: json["cityapN"])
        fares = json["fares"].arrayValue.map { $0.stringValue }
        fq =  Dictionary(uniqueKeysWithValues: json["fq"].map { ( $0.0, $0.1.stringValue ) } )
        pr = priceWS(json: json["pr"])
        stp = json["stp"].arrayValue.map { $0.stringValue }
        al = json["al"].arrayValue.map { $0.stringValue }
        depDt = DateTime(json: json["depDt"])
        arDt = DateTime(json: json["arDt"])
        dt = TimeRange24hoursWS(from: json["dt"])
        at = TimeRange24hoursWS(from: json["at"])
        tt = TimeRangeIntervalWS(json: json["tt"])
            
        
        
        }
        
    }
    
    
}



public struct DateTime  {
    var earliest : String
    var latest : String
    
    init(json : JSON){
        earliest = json["earliest"].stringValue
        latest = json["latest"].stringValue
    }
    
}

public struct cityWiseAirportCode  {
    var fr : [ String : [String]]
    var to : [ String : [String]]
    
    init(json : JSON){
        fr = Dictionary(uniqueKeysWithValues: json["fr"].map( { ( $0.0, $0.1.arrayValue.map { $0.stringValue } ) } ))
        to = Dictionary(uniqueKeysWithValues: json["to"].map( { ( $0.0, $0.1.arrayValue.map { $0.stringValue } ) } ))
    }
    
}



public struct priceWS : Equatable {
    var minPrice : Int
    var maxPrice : Int
    
    init(json : JSON){
        minPrice = json["minPrice"].intValue
        maxPrice = json["maxPrice"].intValue
    }
    
    public static func == (lhs : priceWS , rhs : priceWS ) -> Bool {
        return lhs.minPrice == rhs.minPrice && lhs.maxPrice == rhs.maxPrice
    }
}

public struct TimeRange24hoursWS : Codable , Equatable {
    var earliest : String
    var latest: String
    
    
    init(json : JSON){
        earliest = json["earliest"].stringValue
        latest = json["latest"].stringValue
    }
    
    func convertFrom(timeInterval : TimeInterval ) -> String? {
        
        if timeInterval == 86400 {
            return "24:00"
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let tempDate = Date(timeInterval: timeInterval, since: startOfDay)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: tempDate)
        return timeString
        
    }
    
    
    func convertFrom(string : String ) ->  TimeInterval? {
        
        if string == "24:00" {
            return 86400.0
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.defaultDate = startOfDay
        guard let date = dateFormatter.date(from: string) else { return nil}
        let timeInverval = date.timeIntervalSince(startOfDay)
        return timeInverval
        
    }
    
   mutating func setEarliest( time  : TimeInterval ) {
        
        guard let tempEarliestDate = convertFrom(timeInterval: time) else { return }
        earliest = tempEarliestDate
    }
    
   mutating func setLatest( time : TimeInterval) {
        
        guard let tempLatestDate = convertFrom(timeInterval: time) else { return }
        latest = tempLatestDate
    }
    
    public static func == ( lhs : TimeRange24hoursWS , rhs : TimeRange24hoursWS) -> Bool  {
        return (lhs.earliest == rhs.earliest && lhs.latest == rhs.latest)
    }
    
    var earliestTimeInteval : TimeInterval? {

        return convertFrom(string: earliest)
    }

    var latestTimeInterval : TimeInterval? {
         return convertFrom(string: latest)
    }
}

public struct TimeRangeIntervalWS : Equatable {
    var minTime : String? = "0"
    var maxTime : String? = "0"
    
    init(json : JSON){
        minTime = json["minTime"].stringValue
        maxTime = json["maxTime"].stringValue
    }

    
    
    public static func == (lhs : TimeRangeIntervalWS , rhs : TimeRangeIntervalWS ) -> Bool {
        
        var duration = (lhs.minTime! as NSString).floatValue
        let leftMinValue = CGFloat( floor(duration / 3600.0 ))

        duration = (rhs.minTime! as NSString).floatValue
        let rightMinValue = CGFloat( floor(duration / 3600.0 ))

        duration = (lhs.maxTime! as NSString).floatValue
        let  leftMaxValue = CGFloat( ceil(duration / 3600.0))
        
        duration = (rhs.maxTime! as NSString).floatValue
        let rightMaxValue = CGFloat( ceil(duration / 3600.0))

        return leftMinValue == rightMinValue && leftMaxValue == rightMaxValue
    }
}

public struct TimeRangeTimeZone  {
    var max : String
    var min : String
    
    init(json : JSON){
        max = json["max"].stringValue
        min = json["min"].stringValue
    }

    
}

public struct airportCodes  {
    let ap : [String]
    
    init(json : JSON){
        ap = json["ap"].arrayValue.map { $0.stringValue }
    }
    
}

public struct Humanprice  {
    let total : Float
    let breakup : [String : Float]
    
    init() {
        total = 0
        breakup = [:]
    }
    
    init(json : JSON) {
        total = json["total"].floatValue
        breakup = Dictionary(uniqueKeysWithValues: json["breakup"].map { ($0.0, $0.1.floatValue )} )
    }
    
}

public struct FlightLeg  {
    
    let allAp : [ String]
    let dt : String
    let ad : String
    let ttl : [String]
    var flights : [FlightDetail]
    var fcp : Int?
    let loap : [String]
    let stp : String
    let ap : [String]
    let lott : [Int]
    let dd : String
    let lfk : String
    let at : String
    let al : [ String]
    
    var totalLayOver : Int {
        return  lott.reduce(0){ $0 + $1 }
    }
    
    
    init(json : JSON) {
        allAp = json["allAp"].arrayValue.map { $0.stringValue }
        dt = json["dt"].stringValue
        ad = json["ad"].stringValue
        ttl = json["ttl"].arrayValue.map { $0.stringValue }
        flights = json[""].arrayValue.map { FlightDetail(json: $0)  }
        fcp = json["fcp"].intValue
        loap = json["loap"].arrayValue.map { $0.stringValue }
        stp = json["stp"].stringValue
        loap = json["loap"].arrayValue.map { $0.stringValue }
        ap = json["ap"].arrayValue.map { $0.stringValue }
        dd = json["dd"].stringValue
        lfk = json["lfk"].stringValue
        at = json["at"].stringValue
        al = json["al"].arrayValue.map { $0.stringValue }
    }
    
}

public struct FlightDetail  {
    let ffk : String
    let fr : String
    let to : String
    let dd : String
    let dt : String
    let at : String
    let dmt : String?
    let ad  : String
    let atm : String
    let dtm : String
    let ft : Int
    let al : String
    let fn : String
    let oc : String?
    let eq : String?
    let eqQuality : Int?
    let cc : String
    let ccChg : Int
    let bc : String
    let lo : Int
    let ovgtlo : Int
    let ovgtf : Int
    var halt : String
    let fbn : String

    let slo : Int
    let llo : Int

    var bg : [ String : baggageStruct]?
//    let cbg : [ String : cbgStruct]?
//    let cbg : String?
    let isLcc : Int
    var isArrivalTerminalChange:Bool?
    var isDepartureTerminalChange:Bool?
    
    var isArrivalAirportChange:Bool?
    var isDepartureAirportChange:Bool?
    
    var isDepartureDateChange:Bool?

    var ontimePerformance:Int?
    var latePerformance:Int?
    var cancelledPerformance:Int?
    var observationCount:Int?
    var averageDelay:Int?
    var ontimePerformanceDataStoringTime:String?
    
    
    var ADT_BG_pieces : String?
    var ADT_BG_weight : String?
    var cm : String?
    var inch : String?
    var ADT_BG_note : String?
    var ADT_BG_max_pieces : String?
    var ADT_BG_max_weight : String?

    init(json : JSON) {
        
        ffk = json["ffk"].stringValue
        fr = json["fr"].stringValue
        to = json["to"].stringValue
        dd = json["dd"].stringValue
        dt = json["dt"].stringValue
        at = json["at"].stringValue
        dmt = json["dmt"].stringValue
        ad = json["ad"].stringValue
        atm = json["atm"].stringValue
        dtm = json["dtm"].stringValue
        ft = json["ft"].intValue
        al = json["al"].stringValue
        fn = json["fn"].stringValue
        oc = json["oc"].stringValue
        eq = json["eq"].stringValue
        eqQuality = json["eqQuality"].intValue
        cc = json["cc"].stringValue
        ccChg = json["ccChg"].intValue
        bc = json["bc"].stringValue
        lo = json["lo"].intValue
        ovgtlo = json["ovgtlo"].intValue
        ovgtf = json["ovgtf"].intValue
        halt = json["halt"].stringValue
        fbn = json["fbn"].stringValue
        slo = json["slo"].intValue
        llo = json["llo"].intValue
        bg = Dictionary(uniqueKeysWithValues: json["bg"].map { ($0.0, baggageStruct(json: $0.1)) })
        isLcc = json["isLcc"].intValue
        isArrivalTerminalChange = json["isArrivalTerminalChange"].boolValue
        isDepartureTerminalChange = json["isDepartureTerminalChange"].boolValue
        isArrivalAirportChange = json["isArrivalAirportChange"].boolValue
        isDepartureAirportChange = json["isDepartureAirportChange"].boolValue
        isDepartureDateChange = json["isDepartureDateChange"].boolValue
        ontimePerformance = json["ontimePerformance"].intValue
        latePerformance = json["latePerformance"].intValue
        cancelledPerformance = json["cancelledPerformance"].intValue
        observationCount = json["observationCount"].intValue
        averageDelay = json["averageDelay"].intValue
        ontimePerformanceDataStoringTime = json["ontimePerformanceDataStoringTime"].stringValue
        ADT_BG_max_pieces = json["ADT_BG_max_pieces"].stringValue
        ADT_BG_weight = json["ADT_BG_weight"].stringValue
        cm = json["cm"].stringValue
        inch = json["inch"].stringValue
        ADT_BG_note = json["ADT_BG_note"].stringValue
        ADT_BG_max_pieces = json["ADT_BG_max_pieces"].stringValue
        ADT_BG_max_weight = json["ADT_BG_max_weight"].stringValue
        
    }
    
    
}

public struct AirportDetailsWS  {
    let n : String?
    let c : String?
    let cn : String?
    let lat : String?
    let long : String?
    let hw : String?
    let tz  : String?
    let tzShortname : String?
    let tzOffset : String?
    let tzDisplay : String?
    let cname : String?
    
    
    init(json : JSON) {
        
        n = json["n"].stringValue
        c = json["c"].stringValue
        cn = json["cn"].stringValue
        lat = json["lat"].stringValue
        long = json["long"].stringValue
        hw = json["hw"].stringValue
        tz = json["tz"].stringValue
        tzShortname = json["tzShortname"].stringValue
        tzOffset = json["tzOffset"].stringValue
        tzDisplay = json["tzDisplay"].stringValue
        cname = json["cname"].stringValue


    }
    
}

struct AirlineMasterWS  {
    let name : String
    let bgcolor : String
    let humaneScore : String
    
    
    init( json : JSON) {
        name = json["name"].stringValue
        bgcolor = json["bgcolor"].stringValue
        humaneScore = json["humaneScore"].stringValue
    }
    
}


struct Taxes:Codable {
    var taxes : TotalPayabelSubStruct
    var BF : TaxesSubStruct
    var totalPayableNow : TaxesSubStruct
    let cancellationCharges : cancellationChargesStruct
    let reschedulingCharges : reschedulingChargesStruct
    
    init() {
        taxes = TotalPayabelSubStruct()
        BF = TaxesSubStruct()
        totalPayableNow = TaxesSubStruct()
        cancellationCharges = cancellationChargesStruct()
        reschedulingCharges = reschedulingChargesStruct()
    }
    
    init( json : JSON) {
        
        taxes = TotalPayabelSubStruct(json: json["taxes"])
        BF = TaxesSubStruct(json: json["BF"])
        totalPayableNow = TaxesSubStruct(json: json["totalPayableNow"])
        
    }
    
}

struct TaxesSubStruct {
    let name:String
    var value:Int
    
    init() {
        name = ""
        value = 0
    }
    
    init( json : JSON) {
        name = json["name"].stringValue
        value = json["value"].intValue
    }
}

struct TotalPayabelSubStruct {
    let name:String
    var value:Int
    
    var details : [String:Int]
    
    init() {
        name = ""
        value = 0
        details = [:]
    }
    
    init(json : JSON) {
        name = json["name"].stringValue
        value = json["value"].intValue
        details = Dictionary(uniqueKeysWithValues: json["details"].map { ($0.0, $0.1.intValue) })
        
    }
    
}

struct cancellationChargesStruct {
    let name:String
    let value:Int
    let details : cancellationDetailsStruct
    
    init() {
        name = ""
        value = 0
        details = cancellationDetailsStruct()
    }
    
    init(json : JSON) {
        name = json["name"].stringValue
        value = json["value"].intValue
        //incomplete
    }
    
}
struct reschedulingChargesStruct:Codable {
    let details : reschedulingChargesDetailsStruct
    
    init() {
        details = reschedulingChargesDetailsStruct()
    }
}

struct reschedulingChargesDetailsStruct:Codable {
    let SPRFEE : [String:[String:[cancellationSlabStruct]]]
    let SURFEE : [String:[String:[sucfeeValueStruct]]]
    
    init() {
        SPRFEE = [:]
        SURFEE = [:]
    }
    
    func getAirlineReschedulingDataForAllFlights() -> [[String:[String:[cancellationSlabStruct]]]] {
        var newVal = [[String:[String:[cancellationSlabStruct]]]]()
        newVal.append(SPRFEE)
        return newVal
    }
    
    func getAertripReschedulingDataForAllFlights() -> [[String:[String:[sucfeeValueStruct]]]] {
        var newVal = [[String:[String:[sucfeeValueStruct]]]]()
        newVal.append(SURFEE)
        return newVal
    }
}

struct cbgStruct  {
    let weight : String?
    
    init(json : JSON) {
        weight = json["weight"].stringValue
    }
    
}

struct baggageStruct: Equatable {
    let weight : String?
    let pieces : String?
    let note : String?
    
    init(json : JSON) {
        weight = json["weight"].stringValue
        pieces = json["pieces"].stringValue
        note = json["note"].stringValue

    }
    
}


struct cancellationDetailsStruct:Codable {
    let RAF :  [String:[String:Int]]
    let SPCFEE : [String:[String:[cancellationSlabStruct]]]
    let SUCFEE : [String:[String:[sucfeeValueStruct]]]
    
    init() {
        RAF = [:]
        SPCFEE = [:]
        SUCFEE = [:]
    }
    
    init(json : JSON) {
        
                
        
        Dictionary(uniqueKeysWithValues: json["RAF"].map({ $0.0, Dictionary(uniqueKeysWithValues: json[$0.0].map( { $0.0, $0.1 } ) )  }))

        
    }
    
    
    func getAirlineCancellationDataForAllFlights() -> [[String:[String:[cancellationSlabStruct]]]] {
        var newVal = [[String:[String:[cancellationSlabStruct]]]]()
        newVal.append(SPCFEE)
        return newVal
    }
    
    func getAertripCancellationDataForAllFlights() -> [[String:[String:[sucfeeValueStruct]]]] {
        var newVal = [[String:[String:[sucfeeValueStruct]]]]()
        newVal.append(SUCFEE)
        return newVal
    }
}


struct cancellationSlabStruct {
    let slab : Int?
    let sla : Int?
    let value : Int?
    
    init(json : JSON) {
        
        slab = json["slab"].intValue
        sla = json["sla"].intValue
        value = json["value"].intValue

    }
    
}

struct sucfeeValueStruct {
    let value:Int?
    
    init(json : JSON) {
        value = json["value"].intValue
    }
    
}

struct refundPolicyStruct {
   
    var rfd:[String:Int]
    var rsc:[String:Int]
    
    init() {
        rfd = [:]
        rsc = [:]
    }
    
    init(json : JSON) {
        
        rfd = Dictionary(uniqueKeysWithValues: json["rfd"].map { ($0.0, $0.1.intValue) })
        rsc = Dictionary(uniqueKeysWithValues: json["rsc"].map { ($0.0, $0.1.intValue) })

    }
    
    
}


struct getPinnedURLResponse  {
    
    let success : Bool
    let data :  [String : String]
    
    init(json : JSON)  {
        success = json["success"].boolValue
        data = Dictionary(uniqueKeysWithValues: json["data"].map { ($0.0, $0.1.stringValue) })
    }
    
}

struct updatedFareInfoStruct:Codable{
    let success : Bool
    let data : [String : updatedFareInfoDataStruct]
}

struct updatedFareInfoDataStruct:Codable{
    let rfd : Int
    let rsc : Int
    let cp : cancellationChargesStruct
    let rscp : reschedulingChargesStruct

}

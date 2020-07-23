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
}



public struct DateTime : Codable {
    var earliest : String
    var latest : String
}

public struct cityWiseAirportCode : Codable {
    var fr : [ String : [String]]
    var to : [ String : [String]]
}



public struct priceWS : Codable , Equatable {
    var minPrice : Int
    var maxPrice : Int
    
    
    public static func == (lhs : priceWS , rhs : priceWS ) -> Bool {
        return lhs.minPrice == rhs.minPrice && lhs.maxPrice == rhs.maxPrice
    }
}

public struct TimeRange24hoursWS : Codable , Equatable {
    var earliest : String
    var latest: String
    
    func convertFrom(timeInterval : TimeInterval ) -> String? {
        
        if timeInterval == 86400 {
            return "24.00"
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
        
        if string == "24.00" {
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

public struct TimeRangeIntervalWS : Codable , Equatable {
    var minTime : String?
    var maxTime : String?
    
    public static func == (lhs : TimeRangeIntervalWS , rhs : TimeRangeIntervalWS ) -> Bool {
        
        var duration = (lhs.minTime! as NSString).floatValue
        let leftMinValue = CGFloat( floor(duration / 3600.0 ))

        duration = (rhs.minTime! as NSString).floatValue
        let rightMinValue = CGFloat( floor(duration / 3600.0 ))

        duration = (lhs.maxTime! as NSString).floatValue
        let  leftMaxValue = CGFloat( round(duration / 3600.0))
        
        duration = (rhs.maxTime! as NSString).floatValue
        let rightMaxValue = CGFloat( round(duration / 3600.0))

        return leftMinValue == rightMinValue && leftMaxValue == rightMaxValue
    }
}

public struct TimeRangeTimeZone : Codable {
    let max : String
    let min : String
}

public struct airportCodes : Codable {
    let ap : [String]
}

public struct Humanprice : Codable {
    let total : Float
    let breakup : [String : Float]
}

public struct FlightLeg : Codable {
    
    //    let tt : String
    let allAp : [ String]
    let dt : String
    let ad : String
    let ttl : [String]
    var flights : [FlightDetail]
    // fcp : Fetch Cancellation Policy
    var fcp : Int?
    let loap : [String]
    let stp : String
    let ap : [String]
    let lott : [Int]
    let dd : String
    let lfk : String
    let at : String
    let al : [ String]
//    let fare : [String]?
    
    var totalLayOver : Int {
        return  lott.reduce(0){ $0 + $1 }
    }
}

public struct FlightDetail : Codable {
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
    let halt : String
    let fbn : String

    let slo : Int
    let llo : Int

    var bg : [ String : baggageStruct]?
    let cbg : [ String : cbgStruct]?
//    let cbg : String?
    let isLcc : Int
    var isArrivalTerminalChange:Bool?
    var isDepartureTerminalChange:Bool?
    
    var isArrivalAirportChange:Bool?
    var isDepartureAirportChange:Bool?
    
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

}

public struct AirportDetailsWS : Codable {
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
}

struct AirlineMasterWS : Codable {
    let name : String
    let bgcolor : String
    let humaneScore : String
}


struct Taxes:Codable {
    let taxes : TotalPayabelSubStruct
    let BF : TaxesSubStruct
    let totalPayableNow : TaxesSubStruct
    let cancellationCharges : cancellationChargesStruct
    let reschedulingCharges : reschedulingChargesStruct
}

struct TaxesSubStruct:Codable {
    let name:String
    let value:Int
}

struct TotalPayabelSubStruct:Codable {
    let name:String
    let value:Int
    
    let details : [String:Int]
}

struct cancellationChargesStruct:Codable {
    let name:String
    let value:Int
    
    let details : cancellationDetailsStruct

}
struct reschedulingChargesStruct:Codable {
    let details : reschedulingChargesDetailsStruct
}

struct reschedulingChargesDetailsStruct:Codable {
    let SPRFEE : [String:[String:[cancellationSlabStruct]]]
    let SURFEE : [String:[String:[sucfeeValueStruct]]]
    
    
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

struct cbgStruct:Codable {
    let weight : String?
}

struct baggageStruct:Codable  , Equatable {
    let weight : String?
    let pieces : String?
    let note : String?
}

//struct apiStruct:Codable{
//    let Data : [String :newBGStruct]
//}
//struct newBGStruct:Codable{
//    let Bg : [String:newBaggageStruct]
//}
//
//struct newBaggageStruct:Codable {
//    let pieces : String?
//    let weight : String?
//    let dimension : DimensionStruct?
//    let note : String?
//}
//



struct cancellationDetailsStruct:Codable {
    let RAF :  [String:[String:Int]]
    let SPCFEE : [String:[String:[cancellationSlabStruct]]]
    let SUCFEE : [String:[String:[sucfeeValueStruct]]]
    
    
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


struct cancellationSlabStruct:Codable{
    let slab : Int?
    let sla : Int?
    let value : Int?
}

struct sucfeeValueStruct:Codable{
    let value:Int?
}

struct refundPolicyStruct:Codable {
    let rfd:[String:Int]
    let rsc:[String:Int]
}


struct getPinnedURLResponse : Codable {
    let success : Bool
    let data :  [String : String]
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

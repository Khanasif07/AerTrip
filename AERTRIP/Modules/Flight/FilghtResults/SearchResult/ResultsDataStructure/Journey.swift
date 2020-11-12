//
//  Jounrney.swift
//  Aertrip
//
//  Created by  hrishikesh on 19/07/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit 


//enum baggageStatus {
//    case noBaggage
//    case pieces
//    case weight
//    case unKnown
//    case multipleValues
//}

public class Journey: Codable , Equatable {
    let vendor : String
    let id : String
    var fk : String
    let ofk : String?
    //    let invfk : Bool
    //    let pricingsolutionKey: String
    let otherfares : Bool?
    var farepr : Int
    let iic : Bool
    let displaySeat : Bool
    var fare : Taxes
//    let rfd : Int
    var rfdPlcy:refundPolicyStruct
//    let rsc : Int
    let dt : String
    let at : String
    let tt : [Int]
    // slo : Short Layover
    let slo  : Int
    let slot : String
    //llow : Long layover
    let llow : Int
    let llowt : String
    let red : Int
    let redt : String
    let cot : Int
    let cop : Int
    let copt : String
    // FSR : Few Seats remaining
    let fsr : Int
    let seats : String?
    let al : [String]
    let stp : String
    let ap : [String]
    let loap : [String]
    //    let load : []
    var leg : [FlightLeg]
    let isLcc : Int
    //    let hmnePrms :
    //    let apc :
    let sict : Bool?
    //    let fareBasis
    //    let coat :
    let dspNoshow : Int
    //    let rfdPlcy
    //    let qid :
    let cc : String
    //    let eqt : Int
    // Fcc : Change of flight class. If flight is not available in seach class different / lower class flights is displayed
    let fcc : String?
    // lg = luggage , if lg == 1 lugguage is allowed  if lg == 0 luggauge is not allowed
    let lg : Int
//    let lott : [Int]
    let ovngt : Int
    let ovngtt : String
    let ovgtf : Int
    let ovgtlo : Int
    let dd : String
    let ad : String
    let coa : Int
    let humaneScore : Float
    //    let humaneArr
    let humanePrice : Humanprice
    
    init() {
        self.vendor = ""
        self.id = ""
        self.fk = ""
        self.ofk = ""
        self.otherfares = false
        self.farepr = 0
        self.iic = false
        self.displaySeat = false
        self.fare = Taxes()
        self.rfdPlcy = refundPolicyStruct()
        self.dt = ""
        self.at = ""
        self.tt = []
        self.slo  = 0
        self.slot = ""
        self.llow = 0
        self.llowt = ""
        self.red = 0
        self.redt = ""
        self.cot = 0
        self.cop = 0
        self.copt = ""
        self.fsr = 0
        self.seats = ""
        self.al = []
        self.stp = ""
        self.ap = []
        self.loap = []
        self.leg = []
        self.isLcc = 0
        self.sict = false
        self.dspNoshow = 0
        self.cc = ""
        self.fcc = ""
        self.lg = 0
        self.ovngt = 0
        self.ovngtt = ""
        self.ovgtf = 0
        self.ovgtlo = 0
        self.dd = ""
        self.ad = ""
        self.coa = 0
        self.humaneScore = 0
        self.humanePrice = Humanprice()
    }

    // Computed properties for display and logic
    
    var startTime : String {
        return dt
    }
    
    var departureDate : Date? {
      
        let departure = dd + " " + dt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        return dateFormatter.date(from: departure)
    }
    
    var arrivalDate : Date? {
        
        let arrival = ad + " " + at
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        return dateFormatter.date(from: arrival)
    }
    
    
    var departTimeInterval : TimeInterval {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        let startDayString =  dd + " 00:00"
        let currentDayString = dd + " " + dt
        
        guard let startDate = dateFormatter.date(from: startDayString) else { return 0 }
        guard let currentDate = dateFormatter.date(from: currentDayString) else { return 0 }
        
        let timeInterval = currentDate.timeIntervalSince(startDate)
        return timeInterval
    }
    
    var startTimePercentile : CGFloat {
        
        // finding percentile for 24 hours ratio
        // timeInteval is in seconds.
        let percentile = departTimeInterval / 86400.0
        return CGFloat(percentile)
    }
    
    var arrivalTimeInteval : TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        var startDayString : String
        
        if ( dd == ad ) {
            startDayString =  ad + " 00:00"
        }
        else {
            startDayString =  dd + " 00:00"
        }
        
        let currentDayString = ad + " " + at
        
        guard let startDate = dateFormatter.date(from: startDayString) else { return 0 }
        guard let currentDate = dateFormatter.date(from: currentDayString) else { return 0 }
        
        let timeInterval = currentDate.timeIntervalSince(startDate)
        
        return timeInterval
    }
    
    
    var totalLayOver : Int {
        
        return leg.reduce(0){ $0 + $1.totalLayOver }
    }
    
    var hasCorporateFare  : Bool?
    
    var endTime18Size : NSAttributedString {
        return endtimeWith(Size: 18.0)
    }
    
    
    var endTime16size : NSAttributedString {
        return endtimeWith(Size: 16.0)
    }
    
    func endtimeWith(Size : CGFloat) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font : UIFont(name: "SourceSansPro-SemiBold", size: (Size))!]
        let endTime = NSMutableAttributedString(string: at, attributes: attributes)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        guard let departureDate = dateFormatter.date(from: dd) else {
            assertionFailure("departure date is not coming in YYYY-MM-dd format")
            return endTime
        }
        guard let arrivalDate = dateFormatter.date(from: ad) else {
            assertionFailure("arrival date is not coming in YYYY-MM-dd format")
            return endTime
        }
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: departureDate, to: arrivalDate)
        let numberOfDays = components.day ?? 0
        
        if numberOfDays >= 1 {
            let daysStringAttributes = [NSAttributedString.Key.font : UIFont(name: "SourceSansPro-SemiBold", size: 8.0)! , NSAttributedString.Key.baselineOffset :  NSNumber(6) ]
            let daysSuperscript = "+" + String(numberOfDays)
            let daysSuperScript = NSAttributedString(string: daysSuperscript, attributes: daysStringAttributes)
            endTime.append(daysSuperScript)
        }
        
        return endTime
    }
    
    var duration : Int {
        return  tt.reduce(0){ $0 + $1 }
    }
    
    var airlinesSubString : String?
    var airlineLogoArray : [String]?
    
    
    var smartIconArray : [String]
    {
        
        var logoArray = [ String]()
        
        if coa > 0 { logoArray.append("redchangeAirport") }
        
        if let changeOfflightClass = fcc {
            
            switch changeOfflightClass {
            case "e" :
                logoArray.append("EconomyClassBlack")
            case "pe" :
                logoArray.append("PreEconomyClassBlack")
            case "b" :
                logoArray.append("BusinessClassBlack")
            case "f" :
                logoArray.append("FirstClassBlack")
            default :
                break
            }
        }
        
        if fsr > 0 {
            logoArray.append("fsr")
            
        }
        
        
        if slo > 0 {  logoArray.append("shortLayover") }
        if leg.first?.fcp != 1 && rfdPlcy.rfd.first?.value == 0 { logoArray.append("noRefund")}
        if coa == 0 && cot > 0 { logoArray.append("changeOfTerminal") }
        if ovngt > 0 { logoArray.append("overnight")}
        if llow > 0 { logoArray.append("longLayover") }
        if leg.first?.fcp == 1 { logoArray.append("refundStatusPending")}
        
        return logoArray
    }
    
    var price : Float {
        return humanePrice.total
    }
    
    var priceAsString : String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        formatter.locale = Locale.init(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: farepr)) ?? ""
    }
    
    var intermediateAirports : String {
        
        let count = loap.count
        
        switch  count {
        case 0 :
            return ""
        case 1 :
            return loap[0]
        case 2 :
            return loap[0] + "   " + loap[1]
        default:
            return String(count) + " Stops"
        }
        
    }
    
    var durationTitle : String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        
        guard let formattedString = formatter.string(from: TimeInterval(duration)) else { return "" }
        return formattedString
    }
    
    var originIATACode : String {
        return ap.first ?? ""
    }
    
    var destinationIATACode : String {
        return ap.last ?? ""
    }
    
    var flightCode : String
    {
        guard let first = leg.first else { return "" }
        guard let flight = first.flights.first else { return "" }
        let code = flight.al + " - " + flight.fn
        return code
    }
    
    var isCheapest : Bool?
    var isFastest : Bool? {
        didSet {
            
        }
    }
    var isAboveHumanScore : Bool?
    var computedHumanScore : Float?
    var isPinned : Bool? = false
    var groupID : Int?
    var noBaggage : Bool?
//    var isRefundUpdated : Bool {
//
//        return false
//    }
    
    public static func == (lhs: Journey, rhs: Journey) -> Bool {
        
        if lhs.fk.caseInsensitiveCompare(rhs.fk) == .orderedSame {
            return true
        }
        
        if lhs.ofk?.caseInsensitiveCompare(rhs.fk) == .orderedSame  && !(lhs.sict ?? true ) {
            return true
        }
        
        if rhs.ofk?.caseInsensitiveCompare(lhs.fk) == .orderedSame && !(rhs.sict ?? true){
            return true
        }
        
        return false
    }
    
    
    var baggageSuperScript : NSAttributedString? {
        
        let flights = leg[0].flights
        let baggageArray = flights.compactMap{ $0.bg }

        // When Baggage data is not available from all flights , return baggage unknown status
        if flights.count > baggageArray.count {

            let attributes =   [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Regular", size: 9.0)! ,
                                NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: (253.0/255.0), green: (51.0/255.0), blue: (51.0/255.0), alpha: 1.0)]
            let attributedSuperScript = NSAttributedString(string: "?", attributes: attributes)
            return attributedSuperScript
        }
        

        guard let firstValue = baggageArray.first else {

            let attributes =   [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Regular", size: 9.0)! ,
                                NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: (253.0/255.0), green: (51.0/255.0), blue: (51.0/255.0), alpha: 1.0)]
            let attributedSuperScript = NSAttributedString(string: "?", attributes: attributes)
            return attributedSuperScript
        }
        
        
        if baggageArray.allSatisfy({ $0 == firstValue }) {
            
            let attributes =   [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Regular", size: 9.0)! ,
                                NSAttributedString.Key.foregroundColor : UIColor.black]
            
            if let ADTBaggage = firstValue["ADT"] {
                
                let attributedSuperScript : NSAttributedString
                
                if let pieces = ADTBaggage.pieces, pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0" {
            
                            if pieces.containsIgnoringCase(find: " ") {
                                let numbers = pieces.components(separatedBy: " ")
                                attributedSuperScript = NSAttributedString(string:numbers.first! + "Pc" , attributes: attributes)
                                return attributedSuperScript
                            } else {
                                attributedSuperScript = NSAttributedString(string: pieces + "Pc" , attributes: attributes)
                                return attributedSuperScript
                    }
                }
                
                if let weight = ADTBaggage.weight {
                    
                    if weight.containsIgnoringCase(find: " ") {
                        let numbers = weight.components(separatedBy: " ")
                        attributedSuperScript = NSAttributedString(string:numbers.first!, attributes: attributes)
                        return attributedSuperScript
                    }
                    
                }
                
            }
        } else {

            let attributes =   [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Regular", size: 16.0)! ,
                               NSAttributedString.Key.foregroundColor : UIColor.black]

            let attributedSuperScript = NSAttributedString(string: "*", attributes: attributes)
            return attributedSuperScript
         }

        let attributes =   [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Regular", size: 9.0)! ,
                             NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: (253.0/255.0), green: (51.0/255.0), blue: (51.0/255.0), alpha: 1.0)]
         let attributedSuperScript = NSAttributedString(string: "?", attributes: attributes)
         return attributedSuperScript
    }
    
    
}

struct brandedFaresDataStruct:Codable {
    let otherFares: [[OtherFare]]
    
}

struct OtherFare: Codable {
    let fk: String?
    let farepr: Int?
//    let fare: Fare
    let otherFareClass, fareTypeName, title, bc: [[String]]
//    let subtitle, otherFareDescription: [[String]]
//    let included: [[IncludedUnion]]
    let img: [[String]]
    let apc: String?
//    let flightResult: FlightResult
//    let cancellationRates: CancellationRates
//    let bg: Bg
//    let cbg: Cbg

//    enum CodingKeys: String, CodingKey {
//        case fk, farepr, fare
//        case otherFareClass = "class"
//        case fareTypeName = "FareTypeName"
//        case title, bc, subtitle
//        case otherFareDescription = "description"
//        case included, img, apc
//        case flightResult = "flight_result"
//        case cancellationRates = "cancellation_rates"
//        case bg, cbg
//    }
}

enum OnewayCellType {
    case singleJourneyCell
    case groupedJourneyCell
}


class JourneyOnewayDisplay {
    
    var journeyArray : [Journey]
    var isCollapsed = true
    init (_ journeyArray : [Journey]) {
        self.journeyArray = journeyArray.sorted {  $0.departTimeInterval <  $1.departTimeInterval }
    }
    
    var count : Int {
        return journeyArray.count
    }
    
    var isCheapest : Bool {
        let sorted =  journeyArray.sorted(by: { $0.farepr < $1.farepr })
        return sorted.first!.isCheapest ??  false
    }
    
    var isFastest : Bool {
        
        let sorted =  journeyArray.sorted(by: { $0.duration < $1.duration })
        return  sorted.first?.isFastest ?? false
    }
    
    var first : Journey {
        return journeyArray.first ?? Journey()
    }
    
    var isAboveHumanScore : Bool {
        return first.isAboveHumanScore ?? false
    }
    
    var computedHumanScore : Float {
        guard let jrny = getJourneyWithLeastHumanScore() else { return 0.0 }
        return jrny.computedHumanScore ?? 0.0
    }
    
    //    var isPinned : Bool?
    
    var cellType : OnewayCellType {
        
        if journeyArray.count > 1 {
            return .groupedJourneyCell
        }
        return .singleJourneyCell
    }
    
    var fare : Int {
        
        let sorted =  journeyArray.sorted(by: { $0.farepr < $1.farepr })
        return sorted.first!.farepr
    }
    
    
    
    var debugDescription: String {
        
        var fkArray = [String]()
        
        for jouney in journeyArray {
            
            fkArray.append(jouney.fk)
        }
        
        fkArray.sort(by: {$0 < $1 })
        
        let joined = fkArray.joined(separator: ",")
        let newString = joined.replacingOccurrences(of: ",", with: "\n")
        
        return newString
    }
    
    var containsPinnedFlight : Bool {
        return self.journeyArray.reduce(journeyArray[0].isPinned ?? false ){ $0 || $1.isPinned  ?? false }
    }
    
    var pinnedFlights : [Journey] {
        return self.journeyArray.filter{ $0.isPinned  ?? false }
    }
    
    func setPinned(_ isPinned : Bool , atIndex : Int) {
        self.journeyArray[atIndex].isPinned = isPinned
    }
    
    func isPinned( atIndex : Int) -> Bool {
        return self.journeyArray[atIndex].isPinned  ?? false
    }
    
    func getJourneyWith(fk : String) -> Journey? {
        
        return self.journeyArray.first(where:{ $0.fk == fk })
    }
    
    func getJourneyWithLeastHumanScore () ->  Journey? {
            let sorted =  journeyArray.sorted(by: { $0.computedHumanScore! < $1.computedHumanScore! })
            return sorted.first
    }
    
    func getJourneysWithMinDuration() -> Journey? {
        
        let minJrny = journeyArray.min { (j1, j2) -> Bool in
            return j1.duration < j2.duration
        }
        
         return minJrny
        
    }
    
    func getJourneysWithMaxDuration() -> Journey? {
           
           let minJrny = journeyArray.min { (j1, j2) -> Bool in
               return j1.duration > j2.duration
           }
           
            return minJrny
           
       }
    
    func getJourneysWithMinArivalTime() -> Journey? {
        
        let minJrny = journeyArray.min { (j1, j2) -> Bool in
            
            
            let firstObjDepartureTime = j1.ad + " " + j1.at
                       
            let secondObjDepartureTime = j2.ad + " " + j2.at
          
            let firstObjTimeInterval = firstObjDepartureTime.getTimeIntervalFromDateString(df: "yyyy-MM-dd HH:mm")
                       
            let secondObjTimeInterval = secondObjDepartureTime.getTimeIntervalFromDateString(df: "yyyy-MM-dd HH:mm")
            
            return firstObjTimeInterval < secondObjTimeInterval
        }
        
         return minJrny

    }
    
    func getJourneysWithMaxArivalTime() -> Journey? {
         
         let minJrny = journeyArray.min { (j1, j2) -> Bool in
             
             
             let firstObjDepartureTime = j1.ad + " " + j1.at
                        
             let secondObjDepartureTime = j2.ad + " " + j2.at
           
             let firstObjTimeInterval = firstObjDepartureTime.getTimeIntervalFromDateString(df: "yyyy-MM-dd HH:mm")
                        
             let secondObjTimeInterval = secondObjDepartureTime.getTimeIntervalFromDateString(df: "yyyy-MM-dd HH:mm")
             
             return firstObjTimeInterval > secondObjTimeInterval
         }
         
          return minJrny
         
     }
    
    var selectedFK = String()
    
    var currentSelectedIndex = 0
    
}

//
//  CominationFlightWSResponse.swift
//  Aertrip
//
//  Created by Rishabh on 18/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation


struct IntMultiCityAndReturnWSResponse {
    var data: CombiResponse?
    
    init(_ json: JSON) {
        data = CombiResponse(json["data"])
    }
    
    struct CombiResponse {
        var sid: String
        var completed: Int
        var done: Bool
        var flights: [Flight]?
        
        init(_ json: JSON) {
            sid = json["sid"].stringValue
            completed = json["completed"].intValue
            done = json["done"].boolValue
            flights = json["flights"].arrayValue.map { Flight($0) }
        }
    }
    
    struct Flight {
        var vcode: String
        var displayGroupId: Int
        var qid: String
        var results: Results
        var cfile: Cfile
        
        init(_ json: JSON) {
            vcode = json["vcode"].stringValue
            displayGroupId = json["display_group_id"].intValue
            qid = json["qid"].stringValue
            results = Results(json["results"])
            cfile = Cfile(json["cfile"])
        }
    }
    
    struct Cfile: Codable {
        var unprocessed, raw, processed: String
        
        init(_ json: JSON) {
            unprocessed = json["unprocessed"].stringValue
            raw = json["raw"].stringValue
            processed = json["processed"].stringValue
        }
    }
    
    struct Results {
        var jCount: Int
        var ldet: [String: Ldet]
        var fdet: [String: Fdet]
        var j: [J]
        var f: [F]
        var cityap: [String: [String]]
        var apdet: [String: Apdet]
        var taxes: [String: String]
        var aldet: [String: String]
        var alMaster: [String: ALMaster]
        var eqMaster: [String: EqMaster]
        var vcodeMaster: [String: String]
        var rsid: String
        
        init(_ json: JSON) {
            jCount = json["jCount"].intValue
            ldet = Dictionary(uniqueKeysWithValues: json["ldet"].map { ($0.0, Ldet($0.1)) })
            fdet = Dictionary(uniqueKeysWithValues: json["fdet"].map { ($0.0, Fdet($0.1)) })
            j = json["j"].dictionaryValue.map { J($0.value) }
            f = json["f"].arrayValue.map { F($0) }
            cityap = Dictionary(uniqueKeysWithValues: json["cityap"].map { ($0.0, $0.1.arrayValue.map { $0.stringValue }) })
            apdet = Dictionary(uniqueKeysWithValues: json["apdet"].map { ($0.0, Apdet($0.1)) })
            taxes = Dictionary(uniqueKeysWithValues: json["taxes"].map { ($0.0, $0.1.stringValue) })
            aldet = Dictionary(uniqueKeysWithValues: json["aldet"].map { ($0.0, $0.1.stringValue) })
            alMaster = Dictionary(uniqueKeysWithValues: json["alMaster"].map { ($0.0, ALMaster($0.1)) })
            eqMaster = Dictionary(uniqueKeysWithValues: json["eqMaster"].map { ($0.0, EqMaster($0.1)) })
            vcodeMaster = Dictionary(uniqueKeysWithValues: json["vcodeMaster"].map { ($0.0, $0.1.stringValue) })
            rsid = json["rsid"].stringValue
            
            j = j.map { iterator in
                var j = iterator
                let filteredLDetArr = j.leg.compactMap {ldet[$0]}
                
                j.legsWithDetail = filteredLDetArr
                
                j.legsWithDetail = j.legsWithDetail.map({ ldetIterator in
                    var ldet = ldetIterator
                    ldet.flightsWithDetails = ldet.flights.compactMap {fdet[$0]}
                    return ldet
                })
                return j
            }
        }
            
        struct ALMaster {
            var name, bgcolor, humaneScore: String
            
            init(_ json: JSON) {
                name = json["name"].stringValue
                bgcolor = json["bgcolor"].stringValue
                humaneScore = json["humane_score"].stringValue
            }
        }
        
        struct Apdet {
            var n, c, lat, long: String
            var cn, cname, hw, tz: String
            var tzShortname, tzOffset: String
            var tzDisplay: String
            
            init(_ json: JSON) {
                n = json["n"].stringValue
                c = json["c"].stringValue
                lat = json["lat"].stringValue
                long = json["long"].stringValue
                cn = json["cn"].stringValue
                cname = json["cname"].stringValue
                hw = json["hw"].stringValue
                tz = json["tz"].stringValue
                tzShortname = json["tz_shortname"].stringValue
                tzOffset = json["tz_offset"].stringValue
                tzDisplay = json["tz_display"].stringValue
            }
        }
        
        struct EqMaster {
            var name: String
            var quality: Int
            
            init(_ json: JSON) {
                name = json["name"].stringValue
                quality = json["quality"].intValue
            }
        }
        
        struct J: Equatable {
            static func == (lhs: IntMultiCityAndReturnWSResponse.Results.J, rhs: IntMultiCityAndReturnWSResponse.Results.J) -> Bool {
                if lhs.fk.caseInsensitiveCompare(rhs.fk) == .orderedSame {
                    return true
                }
                
                if lhs.ofk?.caseInsensitiveCompare(rhs.fk) == .orderedSame  && !lhs.sict {
                    return true
                }
                
                if rhs.ofk?.caseInsensitiveCompare(lhs.fk) == .orderedSame && !rhs.sict{
                    return true
                }
                
                return false
            }
            
            var vendor, id, fk, pk, dt, at, slot, llowt, redt, copt, seats, farebasis, coat, cott, cc, ovngtt, dd, ad, pricingSolutionKey, stp: String
            var farepr, slo, llow, red, cot, cop, coa, fsr, isLcc, dspNoShow, eqt, lg, ovngt, ovgtf, ovgtlo, humaneScore: Int
            var ofk: String?
            var fareTypeName: [String: String]
            var otherFares: Bool
            var fare: Fare
            var iic: Bool
            var displaySeat: Bool
            var sict: Bool
            var tt: [Int]
            var al: [String]
            var ap: [String]
            var loap: [String]
            var lott: [Int]
            var leg: [String]
            var legsWithDetail: [Ldet] = []
            var hmnePrms: [[HmnePrms]]
            var rfdPlcy: RfdPlcy
            var qid: String?
            var led: [String: Led]
            var fcc: String?
            var humaneArr: Humane
            var humanePrice: HumanePrice
            var combineJourney = Set<String>()
            var combineFk = Set<String>()
            
            var isCheapest : Bool?
            var isFastest : Bool?
            var isAboveHumanScore : Bool?
            var computedHumanScore : Float?
            var isPinned : Bool = false
            var groupID : Int?
            var noBaggage : Bool?
            var isRefundUpdated : Bool {
                return false
            }
            var duration : Int {
                return  tt.reduce(0){ $0 + $1 }
            }
            var hasCorporateFare  : Bool?
            var airlinesSubString : String?
            var airlineLogoArray : [String]?
            //Added for details from confimation Api
            var cityap: [String: [String]]?
            var apdet: [String: Apdet]?
            var taxes: [String: String]?
            var aldet: [String: String]?
            var addons: [String: AddonsData]?
            //-------------------------------------
            var startTime : String {
                return dt
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
                return llow
            }
            var originIATACode : String {
                return ap.first ?? ""
            }
            
            var midIATACodeInReturn: String {
                return ap.count > 1 ? ap[1] : (ap.last ?? "")
            }
            
            var destinationIATACode : String {
                return ap.last ?? ""
            }
                        
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
            
            var baggageSuperScript : NSAttributedString? {
                
                var flights: [Fdet] = []

//                let flights = legsWithDetail[0].flightsWithDetails
                
                for item in legsWithDetail {
                    flights.append(contentsOf: item.flightsWithDetails)
                }
                
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
                        
                        if let weight = ADTBaggage.weight {
                            
                            if weight.containsIgnoringCase(find: " ") {
                                let numbers = weight.components(separatedBy: " ")
                                attributedSuperScript = NSAttributedString(string:numbers.first!, attributes: attributes)
                                return attributedSuperScript
                            }
                        }
                        
                        if let pieces = ADTBaggage.pieces {
                            
                            if pieces.containsIgnoringCase(find: " ") {
                                let numbers = pieces.components(separatedBy: " ")
                                attributedSuperScript = NSAttributedString(string:numbers.first! + "P" , attributes: attributes)
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
            
            var smartIconArray : [String] {
                
                var logoArray = [ String]()
                
                if coa == 1 { logoArray.append("redchangeAirport") }
                            
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
             
                var isNonRefundable = false
                
                var isRefundStatusUnKnown = false
                
                for key in rfdPlcy.rfd.keys{
                    if rfdPlcy.rfd[key] == 0{
                        isNonRefundable = true
                    }
                }
                
               isRefundStatusUnKnown = !(legsWithDetail.filter { $0.fcp == 1 }.isEmpty)
                
                if isNonRefundable && !isRefundStatusUnKnown {
                    logoArray.append("noRefund")
                }
                
//                if legsWithDetail.first?.fcp != 1 && rfdPlcy.rfd.first?.value == 0 { logoArray.append("noRefund")}
                
                
                if cot == 1 { logoArray.append("changeOfTerminal") }
//                if coa > 0 { logoArray.append("changeOfAirport") }
                if ovngt > 0 { logoArray.append("overnight")}
                if llow > 0 { logoArray.append("longLayover") }
                                
                if isRefundStatusUnKnown {
                    logoArray.append("refundStatusPending")
                }
                
                
                
//                if legsWithDetail.first?.fcp == 1 && !isRefundUpdated { logoArray.append("refundStatusPending")}
                
                //if lg > 0 {  logoArray.append("noBaggage") }
                
                return logoArray
            }
            
            
            init(_ json: JSON) {
                vendor = json["vendor"].stringValue
                id = json["id"].stringValue
                fk = json["fk"].stringValue
                ofk = json["ofk"].stringValue
                pk = json["pk"].stringValue
                dt = json["dt"].stringValue
                at = json["at"].stringValue
                slot = json["slot"].stringValue
                llowt = json["llowt"].stringValue
                redt = json["redt"].stringValue
                copt = json["copt"].stringValue
                seats = json["seats"].stringValue
                farebasis = json["farebasis"].stringValue
                coat = json["coat"].stringValue
                cott = json["cott"].stringValue
                cc = json["cc"].stringValue
                ovngtt = json["ovngtt"].stringValue
                dd = json["dd"].stringValue
                ad = json["ad"].stringValue
                qid = json["qid"].string
                fcc = json["fcc"].string
                pricingSolutionKey = json["pricingsolution_key"].stringValue
                stp = json["stp"].stringValue
                
                farepr = json["farepr"].intValue
                slo = json["slo"].intValue
                llow = json["llow"].intValue
                red = json["red"].intValue
                cot = json["cot"].intValue
                cop = json["cop"].intValue
                coa = json["coa"].intValue
                fsr = json["fsr"].intValue
                isLcc = json["is_lcc"].intValue
                dspNoShow = json["dsp_noshow"].intValue
                eqt = json["eqt"].intValue
                lg = json["lg"].intValue
                ovngt = json["ovngt"].intValue
                ovgtf = json["ovgtf"].intValue
                ovgtlo = json["ovgtlo"].intValue
                
                humaneScore = json["humane_score"].intValue
                fareTypeName = Dictionary(uniqueKeysWithValues: json["fareTypeName"].map { ($0.0, $0.1.stringValue) })
                otherFares = json["otherfares"].boolValue
                iic = json["iic"].boolValue
                displaySeat = json["display_seat"].boolValue
                sict = json["sict"].boolValue
                
                fare = Fare(json["fare"])
                tt = json["tt"].arrayValue.map { $0.intValue }
                al = json["al"].arrayValue.map { $0.stringValue }
                ap = json["ap"].arrayValue.map { $0.stringValue }
                loap = json["loap"].arrayValue.map { $0.stringValue }
                lott = json["lott"].arrayValue.map { $0.intValue }
                leg = json["leg"].arrayValue.map { $0.stringValue }
                
                hmnePrms = json["hmne_prms"].arrayValue.map { $0.arrayValue.map { HmnePrms($0) } }
                
                rfdPlcy = RfdPlcy(json["rfd_plcy"])
                
                led = Dictionary(uniqueKeysWithValues: json["led"].map { ($0.0, Led($0.1)) })
                humaneArr = Humane(json["humane_arr"])
                humanePrice = HumanePrice(json["humane_price"])
                combineJourney = Set(self.leg)
                combineFk.insert(self.fk)
            }
            
            struct HmnePrms {
                var slo: Int
                var llo: Int
                var cop: Int
                var cot: Int
                var coa: Int
                
                init(_ json: JSON) {
                    slo = json["slo"].intValue
                    llo = json["llo"].intValue
                    cop = json["cop"].intValue
                    cot = json["cot"].intValue
                    coa = json["coa"].intValue
                }
            }
            
            struct Fare {
                var bf: Taxes
                var taxes: Taxes
                var grossFare: Taxes
                var grandTotal: Taxes
                var totalPayableNow: Taxes
                var notEffectiveFare: Taxes
                var cancellationCharges: SubFares
                var reschedulingCharges: SubFares//.Details.Fee
                
                init(_ json: JSON) {
                    bf = Taxes(json["BF"])
                    taxes = Taxes(json["taxes"])
                    grossFare = Taxes(json["gross_fare"])
                    grandTotal = Taxes(json["grand_total"])
                    totalPayableNow = Taxes(json["total_payable_now"])
                    notEffectiveFare = Taxes(json["net_effective_fare"])
                    cancellationCharges = SubFares(json["cancellation_charges"])
                    reschedulingCharges = SubFares(json["rescheduling_charges"])
                }
                
                struct Taxes {
                    var name: String
                    var value: Int
                    var details: [String: Int]
                    
                    init(_ json: JSON) {
                        name = json["name"].stringValue
                        value = json["value"].intValue
                        details = Dictionary(uniqueKeysWithValues: json["details"].map { ($0.0, $0.1.intValue) })
                    }
                }
                
                struct SubFares {
                    var name: String
                    var value: Int
                    var details: Details
                    
                    init(_ json: JSON) {
                        name = json["name"].stringValue
                        value = json["value"].intValue
                        details = Details(json["details"])
                    }
                    
                    struct Details {
                        var spcFee: [String: Fee]
                        var sucFee: [String: Fee]
                        var raf: [String:Any]
                        var yq: Int
                        var yr: Int
                        var ot: Int
                        
                        init(_ json: JSON) {
                            if json["SPCFEE"].dictionaryObject != nil{
                                spcFee = Dictionary(uniqueKeysWithValues: json["SPCFEE"].map { ($0.0, Fee($0.1)) })
                                sucFee = Dictionary(uniqueKeysWithValues: json["SUCFEE"].map { ($0.0, Fee($0.1)) })
                            }else{
                                spcFee = Dictionary(uniqueKeysWithValues: json["SPRFEE"].map { ($0.0, Fee($0.1)) })
                                sucFee = Dictionary(uniqueKeysWithValues: json["SURFEE"].map { ($0.0, Fee($0.1)) })
                            }
                            
                            raf = json["RAF"].object as? [String:Any] ?? [:]
                            yq = json["YQ"].intValue
                            yr = json["YR"].intValue
                            ot = json["OT"].intValue
                        }
                        
                        struct Fee {
                            var feeDetail: [String: [FeeDetail]]
                            
                            init(_ json: JSON) {
                                feeDetail = Dictionary(uniqueKeysWithValues: json.map { ($0.0, $0.1.arrayValue.map { FeeDetail($0) }) })
                            }
                            
                            struct FeeDetail {
                                var slab: Int
                                var sla: Int
                                var value: Int
                                
                                init(_ json: JSON) {
                                    slab = json["slab"].intValue
                                    sla = json["sla"].intValue
                                    value = json["value"].intValue
                                }
                            }
                        }
                        
                    }
                }
            }
            
            struct RfdPlcy {
                var cp: Fare.SubFares.Details
                var rscp: Rscp
                var rfd: [String: Int]
                var rsc: [String: Int]
                
                init(_ json: JSON) {
                    cp = Fare.SubFares.Details(json["cp"])
                    rscp = Rscp(json["rscp"])
                    rfd = Dictionary(uniqueKeysWithValues: json["rfd"].map { ($0.0, $0.1.intValue) })
                    rsc = Dictionary(uniqueKeysWithValues: json["rsc"].map { ($0.0, $0.1.intValue) })
                }
                
                struct Rscp {
                    var sprFee: Fare.SubFares.Details.Fee
                    var surFee: Fare.SubFares.Details.Fee
                    
                    init(_ json: JSON) {
                        sprFee = Fare.SubFares.Details.Fee(json["SPRFEE"])
                        surFee = Fare.SubFares.Details.Fee(json["SURFEE"])
                    }
                }
            }
            
            struct Led {
                var fcp: Int
                var fd: [String: FD]
                
                init(_ json: JSON) {
                    fcp = json["fcp"].intValue
                    fd = Dictionary(uniqueKeysWithValues: json["fd"].map { ($0.0, FD($0.1)) })
                }
                
                struct FD {
                    var fbn: String
                    var bc: String
                    var bg: [String: BaggageDetails]
                    var cbg: String
                    var lo: String
                    var llo: Int
                    var slo: Int
                    var ovgtlo: Int
                    
                    init(_ json: JSON) {
                        fbn = json["fbn"].stringValue
                        bc = json["bc"].stringValue
                        bg = Dictionary(uniqueKeysWithValues: json["bg"].map { ($0.0, BaggageDetails($0.1)) })
                        cbg = json["cbg"].stringValue
                        lo = json["lo"].stringValue
                        llo = json["llo"].intValue
                        slo = json["slo"].intValue
                        ovgtlo = json["ovgtlo"].intValue
                    }
                        
                    struct BaggageDetails: Equatable {
                        var weight: String?
                        var pieces: String?
                        var maxWeight: String
                        var maxPieces: String
                        var dimension: String
                        var note: String
                        
                        init(_ json: JSON) {
                            weight = json["weight"].stringValue
                            pieces = json["pieces"].stringValue
                            maxWeight = json["maxWeight"].stringValue
                            maxPieces = json["maxPieces"].stringValue
                            dimension = json["dimension"].stringValue
                            note = json["note"].stringValue
                        }
                    }
                }
            }
            
            struct Humane {
                var cc: Int
                var stp: Int
                var co: [[J.HmnePrms]]
                var nonref: Int
                var al: [String: Int]
                var ap: [String: Int]
                var eq: Int
                
                init(_ json: JSON) {
                    cc = json["cc"].intValue
                    stp = json["note"].intValue
                    co = json["co"].arrayValue.map { $0.arrayValue.map { J.HmnePrms($0) } }
                    nonref = json["nonref"].intValue
                    al = Dictionary(uniqueKeysWithValues: json["al"].map { ($0.0, $0.1.intValue) })
                    ap = Dictionary(uniqueKeysWithValues: json["ap"].map { ($0.0, $0.1.intValue) })
                    eq = json["eq"].intValue
                }
            }
            
            struct HumanePrice {
                var total: Float
                var breakup: Breakup
                
                init(_ json: JSON) {
                    total = json["total"].floatValue
                    breakup = Breakup(json["breakup"])
                }
                
                struct Breakup {
                    var orgPrice: Int
                    
                    init(_ json: JSON) {
                        orgPrice = json["org_price"].intValue
                    }
                }
            }
        }
        
        struct Ldet {
            var fcp: Int
            var allAp: [String]
            var ap: [String]
            var loap: [String]
            var lott: [Int]
            var lfk: String
            var lid: String
            var tt: Int
            var stp: String
            var flights: [String]
            var flightsWithDetails: [Fdet] = []
            var dd: String
            var dt: String
            var ad: String
            var at: String
            var al: [String]
            var ttl: [String]
            
            var airlinesSubString : String?
            var airlineLogoArray : [String]?
            var isDisabled = false
            
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
            
            var originIATACode : String {
                return ap.first ?? ""
            }
            
            var destinationIATACode : String {
                return ap.last ?? ""
            }
            
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
            
            var baggageSuperScript : NSAttributedString? {
                
                let flights = flightsWithDetails
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
                        
                        if let weight = ADTBaggage.weight {
                            
                            if weight.containsIgnoringCase(find: " ") {
                                let numbers = weight.components(separatedBy: " ")
                                attributedSuperScript = NSAttributedString(string:numbers.first!, attributes: attributes)
                                return attributedSuperScript
                            }
                        }
                        
                        if let pieces = ADTBaggage.pieces {
                            
                            if pieces.containsIgnoringCase(find: " ") {
                                let numbers = pieces.components(separatedBy: " ")
                                attributedSuperScript = NSAttributedString(string:numbers.first! + "P" , attributes: attributes)
                                return attributedSuperScript
                            }
                        }
                    }
                }
                 else {

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
            
            var duration : Int {
                return  tt
            }
            
            var durationTitle : String {
                
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                formatter.unitsStyle = .abbreviated
                
                guard let formattedString = formatter.string(from: TimeInterval(duration)) else { return "" }
                if formattedString.split(separator: " ").count == 2{
                    if let minuts = Int(formattedString.components(separatedBy: " ")[1].replacingOccurrences(of: "m", with: "")){
                        let minutsStr = String(format: "%02d", minuts) + "m"
                        return formattedString.components(separatedBy: " ")[0] + " " + minutsStr
                    }
                }
                return formattedString
            }
            
            var isFastest : Bool?
            
            init(_ json: JSON) {
                fcp = json["fcp"].intValue
                allAp = json["all_ap"].arrayValue.map { $0.stringValue }
                ap = json["ap"].arrayValue.map { $0.stringValue }
                loap = json["loap"].arrayValue.map { $0.stringValue }
                lott = json["lott"].arrayValue.map { $0.intValue }
                lfk = json["lfk"].stringValue
                lid = json["lid"].stringValue
                tt = json["tt"].intValue
                stp = json["stp"].stringValue
                flights = json["flights"].arrayValue.map { $0.stringValue }
                dd = json["dd"].stringValue
                dt = json["dt"].stringValue
                ad = json["ad"].stringValue
                at = json["at"].stringValue
                al = json["al"].arrayValue.map { $0.stringValue }
                ttl = json["ttl"].arrayValue.map { $0.stringValue }
            }
            
            var totalLayOver : Int {
                return  lott.reduce(0){ $0 + $1 }
            }
        }
        
        struct Fdet {
            var ffk, fr, to, dd, dt, dtm, ad, at, atm, al, fn, oc, eq, cc, bc, fbc, lo, halt, fbn: String
            var bg: [String: J.Led.FD.BaggageDetails]
            var cbg: [String: J.Led.FD.BaggageDetails]
            var ft, isLcc, tt, eqQuality, llo, slo, ccChg, ovgtf, ovgtlo: Int
            
            var isArrivalTerminalChange:Bool?
            var isDepartureTerminalChange:Bool?
            var isArrivalDateChange:Bool?
            var isDepartureDateChange:Bool?
            var isArrivalAirportChange:Bool?
            var isDepartureAirportChange:Bool?
            var ontimePerformance:Int?
            var latePerformance:Int?
            var cancelledPerformance:Int?
            var observationCount:Int?
            var averageDelay:Int?
            var ontimePerformanceDataStoringTime:String?
            
            init(_ json: JSON) {
                ffk = json["ffk"].stringValue
                fr = json["fr"].stringValue
                to = json["to"].stringValue
                dd = json["dd"].stringValue
                dt = json["dt"].stringValue
                dtm = json["dtm"].stringValue
                ad = json["ad"].stringValue
                at = json["at"].stringValue
                atm = json["atm"].stringValue
                al = json["al"].stringValue
                fn = json["fn"].stringValue
                oc = json["oc"].stringValue
                eq = json["eq"].stringValue
                cc = json["cc"].stringValue
                bc = json["bc"].stringValue
                fbc = json["fbc"].stringValue
                lo = json["lo"].stringValue
//                cbg = json["cbg"].stringValue
                halt = json["halt"].stringValue
                fbn = json["fbn"].stringValue
                ft = json["ft"].intValue
                isLcc = json["is_lcc"].intValue
                tt = json["tt"].intValue
                eqQuality = json["eq_quality"].intValue
                llo = json["llo"].intValue
                slo = json["slo"].intValue
                ccChg = json["cc_chg"].intValue
                ovgtf = json["ovgtf"].intValue
                ovgtlo = json["ovgtlo"].intValue
                bg = Dictionary(uniqueKeysWithValues: json["bg"].map { ($0.0, J.Led.FD.BaggageDetails($0.1)) })
                cbg = Dictionary(uniqueKeysWithValues: json["cbg"].map { ($0.0, J.Led.FD.BaggageDetails($0.1)) })

            }
            
            var flightCode : String
            {
                let code = al + " - " + fn
                return code
            }
        }
        
        struct F {
            var multiAl: Int
            var cityapn: Cityapn
            var fares: [String]
            var fq: [String: String]
            var pr: Pr
            var eq: [String]
            var vcode: [String]
            var stp: [String]
            var al: [String]
            var depDt: DateModel
            var arDt: DateModel
            var dt: DateModel
            var at: DateModel
            var tt: TimeModel
            var loap: [String]
            var lott: TimeModel
            var originTz: MinMaxTZ
            var destinationTz: MinMaxTZ
            var ap: [String]
            var cityAp: [String: [String]]
            var allLayoversSelected = false
            
            init(_ json: JSON) {
                multiAl = json["multi_al"].intValue
                cityapn = Cityapn(json["cityap_n"])
                fares = json["fares"].arrayValue.map { $0.stringValue }
                fq = Dictionary(uniqueKeysWithValues: json["fq"].map { ($0.0, $0.1.stringValue) })
                pr = Pr(json["pr"])
                eq = json["eq"].arrayValue.map { $0.stringValue }
                vcode = json["vcode"].arrayValue.map { $0.stringValue }
                stp = json["stp"].arrayValue.map { $0.stringValue }
                al = json["al"].arrayValue.map { $0.stringValue }
                depDt = DateModel(json["dep_dt"])
                arDt = DateModel(json["ar_dt"])
                dt = DateModel(json["dt"])
                at = DateModel(json["at"])
                tt = TimeModel(json["tt"])
                loap = json["loap"].arrayValue.map { $0.stringValue }
                lott = TimeModel(json["lott"])
                originTz = MinMaxTZ(json["origin_tz"])
                destinationTz = MinMaxTZ(json["destination_tz"])
                ap = json["ap"].arrayValue.map { $0.stringValue }
                cityAp = Dictionary(uniqueKeysWithValues: json["cityap"].map { ($0.0, $0.1.arrayValue.map { $0.stringValue }) })
            }
            
            struct Cityapn {
                var fr: [String: [String]]
                var to: [String: [String]]
                var returnOriginAirports : [String] = []
                var returnDestinationAirports: [String] = []
                
                init(_ json: JSON) {
                    fr = Dictionary(uniqueKeysWithValues: json["fr"].map { ($0.0, $0.1.arrayValue.map { $0.stringValue }) })
                    to = Dictionary(uniqueKeysWithValues: json["to"].map { ($0.0, $0.1.arrayValue.map { $0.stringValue }) })
                }
            }
            
            struct Pr: Equatable {
                var minPrice: Int
                var maxPrice: Int
                
                init(_ json: JSON) {
                    minPrice = json["minPrice"].intValue
                    maxPrice = json["maxPrice"].intValue
                }
                
                public static func == (lhs : Pr , rhs : Pr ) -> Bool {
                    return lhs.minPrice == rhs.minPrice && lhs.maxPrice == rhs.maxPrice
                }
            }
            
            struct DateModel: Equatable {
                var earliest: String
                var latest: String
                
                init(_ json: JSON) {
                    earliest = json["earliest"].stringValue
                    latest = json["latest"].stringValue
                }
                
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
                 
                 
                func convertFrom(string : String, dateFormat : String) ->  TimeInterval? {
                     
                     if string == "24.00" {
                         return 86400.0
                     }
                     
                     let calendar = Calendar.current
                     let startOfDay = calendar.startOfDay(for: Date())
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = dateFormat
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
                 
                 public static func == ( lhs : DateModel , rhs : DateModel) -> Bool  {
                    return (lhs.earliest == rhs.earliest && lhs.latest == rhs.latest)
                 }
                 
                 var earliestTimeInteval : TimeInterval? {

                     return convertFrom(string: earliest, dateFormat: "HH:mm")
                 }

                 var latestTimeInterval : TimeInterval? {
                      return convertFrom(string: latest, dateFormat: "HH:mm")
                 }
                
                var earliestTimeIntevalWithDate : TimeInterval? {
                    return convertFrom(string: earliest, dateFormat: "yyyy-MM-dd HH:mm")
                }
                
                var latestTimeIntervalWithDate : TimeInterval? {
                     return convertFrom(string: latest, dateFormat: "yyyy-MM-dd HH:mm")
                }
                
            }
            
            struct TimeModel: Equatable {
                var minTime: String?
                var maxTime: String?
                
                public static func == (lhs : TimeModel , rhs : TimeModel) -> Bool {
                    
                    var duration = ((lhs.minTime ?? "") as NSString).floatValue
                    let leftMinValue = CGFloat( floor(duration / 3600.0 ))

                    duration = ((rhs.minTime ?? "") as NSString).floatValue
                    let rightMinValue = CGFloat( floor(duration / 3600.0 ))

                    duration = ((lhs.maxTime ?? "") as NSString).floatValue
                    let  leftMaxValue = CGFloat( round(duration / 3600.0))
                    
                    duration = ((rhs.maxTime ?? "") as NSString).floatValue
                    let rightMaxValue = CGFloat( round(duration / 3600.0))

                    return leftMinValue == rightMinValue && leftMaxValue == rightMaxValue
                }
                
                init(_ json: JSON) {
                    minTime = json["minTime"].stringValue
                    maxTime = json["maxTime"].stringValue
                }
            }
            
            struct MinMaxTZ {
                var min: String
                var max: String
                
                init(_ json: JSON) {
                    min = json["min"].stringValue
                    max = json["max"].stringValue

                }
            }
        }
        
        
        
        func setAirlinesToJourney (_ journey : [J] ,  airlineMasterTable : [ String :ALMaster] ) -> [J] {
            
            let modifiedJourneyArray = journey.map({ (journey) -> J in
                var newJourney = journey
                let airlineArray = journey.al
                
                newJourney.legsWithDetail = newJourney.legsWithDetail.map { (legDetail) -> IntMultiCityAndReturnWSResponse.Results.Ldet in
                    var newLegDetail = legDetail
                    let legAirlineArr = legDetail.al
                    switch legAirlineArr.count {
                    case 1:
                        let airlineCode = legAirlineArr[0]
                        let airlineName = airlineMasterTable[airlineCode]?.name
                        newLegDetail.airlinesSubString = airlineName
                    default:
                        newLegDetail.airlinesSubString = String(legAirlineArr.count) + " Carriers"
                    }
                    
                    var logoArray = [String]()
                    for airline in legAirlineArr {
                        let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + airline.uppercased() + ".png"
                        logoArray.append(logoURL)
                    }
                    newLegDetail.airlineLogoArray = logoArray
                    return newLegDetail
                }
                
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
    
}


extension IntJourney{
    init(jsonData:JSON) {
        vendor = jsonData["vendor"].stringValue
        id = jsonData["id"].stringValue
        fk = jsonData["fk"].stringValue
        ofk = jsonData["ofk"].stringValue
        pk = jsonData["pk"].stringValue
        dt = jsonData["dt"].stringValue
        at = jsonData["at"].stringValue
        slot = jsonData["slot"].stringValue
        llowt = jsonData["llowt"].stringValue
        redt = jsonData["redt"].stringValue
        copt = jsonData["copt"].stringValue
        seats = jsonData["seats"].stringValue
        farebasis = jsonData["farebasis"].stringValue
        coat = jsonData["coat"].stringValue
        cott = jsonData["cott"].stringValue
        cc = jsonData["cc"].stringValue
        ovngtt = jsonData["ovngtt"].stringValue
        dd = jsonData["dd"].stringValue
        ad = jsonData["ad"].stringValue
        qid = jsonData["qid"].string
        fcc = jsonData["fcc"].string
        pricingSolutionKey = jsonData["pricingsolution_key"].stringValue
        stp = jsonData["stp"].stringValue
        
        farepr = jsonData["farepr"].intValue
        slo = jsonData["slo"].intValue
        llow = jsonData["llow"].intValue
        red = jsonData["red"].intValue
        cot = jsonData["cot"].intValue
        cop = jsonData["cop"].intValue
        coa = jsonData["coa"].intValue
        fsr = jsonData["fsr"].intValue
        isLcc = jsonData["is_lcc"].intValue
        dspNoShow = jsonData["dsp_noshow"].intValue
        eqt = jsonData["eqt"].intValue
        lg = jsonData["lg"].intValue
        ovngt = jsonData["ovngt"].intValue
        ovgtf = jsonData["ovgtf"].intValue
        ovgtlo = jsonData["ovgtlo"].intValue
        
        humaneScore = jsonData["humane_score"].intValue
        fareTypeName = Dictionary(uniqueKeysWithValues: jsonData["fareTypeName"].map { ($0.0, $0.1.stringValue) })
        otherFares = jsonData["otherfares"].boolValue
        iic = jsonData["iic"].boolValue
        displaySeat = jsonData["display_seat"].boolValue
        sict = jsonData["sict"].boolValue
        fare = Fare(jsonData["fare"])
        tt = jsonData["tt"].arrayValue.map { $0.intValue }
        al = jsonData["al"].arrayValue.map { $0.stringValue }
        ap = jsonData["ap"].arrayValue.map { $0.stringValue }
        loap = jsonData["loap"].arrayValue.map { $0.stringValue }
        lott = jsonData["lott"].arrayValue.map { $0.intValue }
        leg = jsonData["leg"].arrayValue.map{$0["lfk"].stringValue}
        hmnePrms = jsonData["hmne_prms"].arrayValue.map { $0.arrayValue.map { HmnePrms($0) } }
        rfdPlcy = RfdPlcy(jsonData["rfd_plcy"])
        led = Dictionary(uniqueKeysWithValues: jsonData["led"].map { ($0.0, Led($0.1)) })
        humaneArr = Humane(jsonData["humane_arr"])
        humanePrice = HumanePrice(jsonData["humane_price"])
        combineJourney = Set(self.leg)
        combineFk.insert(self.fk)
        legsWithDetail = jsonData["leg"].arrayValue.map{IntMultiCityAndReturnWSResponse.Results.Ldet(jsonData: $0)}
        cityap = Dictionary(uniqueKeysWithValues: jsonData["cityap"].map { ($0.0, $0.1.arrayValue.map { $0.stringValue }) })
        apdet = Dictionary(uniqueKeysWithValues: jsonData["apdet"].map { ($0.0, IntMultiCityAndReturnWSResponse.Results.Apdet($0.1)) })
        taxes = Dictionary(uniqueKeysWithValues: jsonData["taxes"].map { ($0.0, $0.1.stringValue) })
        aldet = Dictionary(uniqueKeysWithValues: jsonData["aldet"].map { ($0.0, $0.1.stringValue) })
        addons = Dictionary(uniqueKeysWithValues: jsonData["addons"].map { ($0.0, AddonsData($0.1)) })
        
    }
    
}


extension IntMultiCityAndReturnWSResponse.Results.Ldet{
    
    init(jsonData:JSON) {
        fcp = jsonData["fcp"].intValue
        allAp = jsonData["all_ap"].arrayValue.map { $0.stringValue }
        ap = jsonData["ap"].arrayValue.map { $0.stringValue }
        loap = jsonData["loap"].arrayValue.map { $0.stringValue }
        lott = jsonData["lott"].arrayValue.map { $0.intValue }
        lfk = jsonData["lfk"].stringValue
        lid = jsonData["lid"].stringValue
        tt = jsonData["tt"].intValue
        stp = jsonData["stp"].stringValue
        flights = jsonData["flights"].arrayValue.map{$0["ffk"].stringValue}
        dd = jsonData["dd"].stringValue
        dt = jsonData["dt"].stringValue
        ad = jsonData["ad"].stringValue
        at = jsonData["at"].stringValue
        al = jsonData["al"].arrayValue.map { $0.stringValue }
        ttl = jsonData["ttl"].arrayValue.map { $0.stringValue }
        flightsWithDetails = jsonData["flights"].arrayValue.map{IntFlightDetail($0)}
    }
    
    
}


struct AddonsData {
    var baggage : [Addons]
    var meal : [Addons]
    var special : [Addons]
    init(_ json:JSON = JSON()) {
        baggage = json["baggage"].arrayValue.map{Addons($0)}
        meal = json["meal"].arrayValue.map{Addons($0)}
        special = json["special"].arrayValue.map{Addons($0)}
    }
}

struct Addons{
    
    var fk : String
    var ssrCode : String
    var addonType : String
    var serviceCost : Int
    var serviceName : String
    var feeCode : String
    var feeType : String
    var chargeDetails : Int
    var isReadonly : Int
    var paxType : String
    var id : String
    var fareStructureId : String
    var fareCodeId : String
    var fareCode : String
    var fareFrontendName : String
    var aliases : String
    var fareGroupId : String
    var groupName : String
    var groupSlug : String
    var groupType : String
    var inRetail : String
    var addToForRetail : String
    var sortOrder : String
    var managementValuesFrom : String
    var calculationRule : String
    var apply : String
    var percent : String?
    var amount : String?
    var calculateOn : String
    var entityType : String
    var salesAccountMasterId : String
    var purchaseAccountMasterId : String
    var purchasePrice : Int
    var salePrice : Int
    var mealsSelectedFor : [ATContact] = []
    var autoSelectedFor : [String] = []
    var bagageSelectedFor : [ATContact] = []
    
    
    init(_ json:JSON = JSON()) {
        fk = json["fk"].stringValue
         ssrCode = json["ssr_code"].stringValue
         addonType = json["addon_type"].stringValue
         serviceCost = json["service_cost"].intValue
         serviceName = json["service_name"].stringValue
         feeCode = json["fee_code"].stringValue
         feeType = json["fee_type"].stringValue
         chargeDetails = json["charge_details"].intValue
         isReadonly = json["is_readonly"].intValue
         paxType = json["pax_type"].stringValue
         id = json["id"].stringValue
         fareStructureId = json["fare_structure_id"].stringValue
         fareCodeId = json["fare_code_id"].stringValue
         fareCode = json["fare_code"].stringValue
         fareFrontendName = json["fare_frontend_name"].stringValue
         aliases = json["aliases"].stringValue
         fareGroupId = json["fare_group_id"].stringValue
         groupName = json["group_name"].stringValue
         groupSlug = json["group_slug"].stringValue
         groupType = json["group_type"].stringValue
         inRetail = json["in_retail"].stringValue
         addToForRetail = json["add_to_for_retail"].stringValue
         sortOrder = json["sort_order"].stringValue
         managementValuesFrom = json["management_values_from"].stringValue
         calculationRule = json["calculation_rule"].stringValue
         apply = json["apply"].stringValue
         percent = json["percent"].string
         amount = json["amount"].string
         calculateOn = json["calculate_on"].stringValue
         entityType  = json["entity_type"].stringValue
         salesAccountMasterId  = json["sales_account_master_id"].stringValue
         purchaseAccountMasterId  = json["purchase_account_master_id"].stringValue
         purchasePrice  = json["purchase_price"].intValue
         salePrice = json["sale_price"].intValue
    }
    
}

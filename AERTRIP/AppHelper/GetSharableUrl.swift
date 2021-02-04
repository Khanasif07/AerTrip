//
//  GetSharableUrl.swift
//  Aertrip
//
//  Created by Monika Sonawane on 31/07/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

protocol GetSharableUrlDelegate : AnyObject {
    func returnSharableUrl(url:String)
    func returnEmailView(view:String)
}

import Foundation
import UIKit

class GetSharableUrl
{
    weak var delegate : GetSharableUrlDelegate?
    var semaphore = DispatchSemaphore (value: 0)
    var tripType = ""
    var searchParam = JSONDictionary()
    
    func getUrl(adult:String, child:String, infant:String,isDomestic:Bool, isInternational:Bool, journeyArray:[Journey], valString:String,trip_type:String, filterString:String,searchParam:JSONDictionary?)
    {
        self.searchParam = searchParam ?? [:]
        tripType = trip_type
        var valueString = ""

        if !isInternational{
            let cc = journeyArray.first?.cc ?? ""
            let origin = getOrigin(journey: journeyArray)
            let destination = getDestination(journey: journeyArray)
            let departureDate = getDepartureDate(journey: journeyArray)
            let returnDate = getReturnDate(journey: journeyArray)
            let pinnedFlightFK = getPinnedFlightFK(journey: journeyArray)

            valueString = "\(APIEndPoint.shareableBaseUrl.rawValue)flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)\(filterString)"
            
            printDebug(valueString)

        }

        var param = JSONDictionary()
        if isInternational{
            param = ["u": valString]
        }else{
            param = ["u": valueString]
        }
        
        APICaller.shared.getShortUrlForShare(params: param) {[weak self] (success,data, error) in
            guard let self = self , let shortUrldata = data else {
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
                return
            }
            
            if success{
                if let shortUrl = shortUrldata["u"] as? String{
                    if !shortUrl.isEmpty{
                        self.delegate?.returnSharableUrl(url: shortUrl)
                    }else{
                        self.delegate?.returnSharableUrl(url: "No Data")
                    }
                }
            }else{
                self.delegate?.returnSharableUrl(url: "No Data")
            }
        }
    }
//    {
//        self.searchParam = searchParam ?? [:]
//        tripType = trip_type
//        var valueString = ""
//
//        if !isInternational{
//            let cc = journeyArray.first?.cc ?? ""
//            let origin = getOrigin(journey: journeyArray)
//            let destination = getDestination(journey: journeyArray)
//            let departureDate = getDepartureDate(journey: journeyArray)
//            let returnDate = getReturnDate(journey: journeyArray)
//            let pinnedFlightFK = getPinnedFlightFK(journey: journeyArray)
//
//            valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)\(filterString)"
//
//        }
//
//        let pinnedUrl = flightBaseUrl+"get-pinned-url"
//        var parameters = [[String : Any]]()
//        if isInternational{
//            parameters = [
//                [
//                    "key": "u",
//                    "value": valString,
//                    "type": "text"
//                ]] as [[String : Any]]
//        }else{
//            parameters = [
//                [
//                    "key": "u",
//                    "value": valueString,
//                    "type": "text"
//                ]] as [[String : Any]]
//        }
//
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var body = ""
//        var _: Error? = nil
//        for param in parameters {
//            if param["disabled"] == nil {
//                let paramName = param["key"] ?? ""
//                body += "--\(boundary)\r\n"
//                body += "Content-Disposition:form-data; name=\"\(paramName)\""
//                let paramType = param["type"] as? String ?? ""
//                if paramType == "text" {
//                    let paramValue = param["value"] as? String ?? ""
//                    body += "\r\n\r\n\(paramValue)\r\n"
//                }
//            }
//        }
//        body += "--\(boundary)--\r\n";
//        let postData = body.data(using: .utf8)
//
//        guard let url = URL(string: pinnedUrl) else {return}
//
//        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
//        request.addValue(apiKey, forHTTPHeaderField: "api-key")
//        request.addValue("AT_R_STAGE_SESSID=cba8fbjvl52c316a4b24tuank4", forHTTPHeaderField: "Cookie")
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                printDebug(String(describing: error))
//                return
//            }
//
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//            do{
//                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
//
//                DispatchQueue.main.async {
//                    if let result = jsonResult as? [String: AnyObject] {
//                        if result["success"] as? Bool == true{
//
//                            if let data = (result["data"] as? [String:Any]){
//                                if let link = data["u"] as? String{
//                                    self.delegate?.returnSharableUrl(url: link)
//                                }
//                            }
//                        }else{
//                            self.delegate?.returnSharableUrl(url: "No Data")
//                        }
//                    }
//                }
//            }catch{
//            }
//
//            self.semaphore.signal()
//        }
//
//        task.resume()
//        semaphore.wait()
//    }
    
    
    
    func getUrlForMail(adult:String, child:String, infant:String,isDomestic:Bool, sid:String, isInternational:Bool, journeyArray:[Any],valString:String, trip_type:String)
    {
        tripType = trip_type
        let tempelteUrl = flightBaseUrl+"get-pinned-template"

        var valueString = ""
        if !isInternational{
            let cc = (journeyArray as? [Journey])?.first?.cc ?? ""
            let origin = getOrigin(journey: (journeyArray as? [Journey]) ?? [])
            let destination = getDestination(journey: (journeyArray as? [Journey]) ?? [])
            let departureDate = getDepartureDate(journey: (journeyArray as? [Journey]) ?? [])
            let returnDate = getReturnDate(journey: (journeyArray as? [Journey]) ?? [])
            let pinnedFlightFK = getPinnedFlightFK(journey: (journeyArray as? [Journey]) ?? [])


            valueString = "\(APIEndPoint.shareableBaseUrl.rawValue)flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)"
        }

        var parameters = [[String : Any]]()
        for i in 0..<journeyArray.count{
            if isInternational{
                let test = [
                    "key": "fk[\(i)]",
                    "value": (journeyArray as? [IntMultiCityAndReturnWSResponse.Results.J])?[i].fk ?? "",
                    "type": "text"
                ]

                parameters.append(test)
            }else{
                let test = [
                    "key": "fk[\(i)]",
                    "value": (journeyArray as? [Journey])?[i].fk ?? "",
                    "type": "text"
                ]

                parameters.append(test)
            }
        }

        if isInternational{
            parameters.append([
                "key": "u",
                "value": valString,
                "type": "text"
            ])
        }else{
            parameters.append([
                "key": "u",
                "value": valueString,
                "type": "text"
            ])
        }

        parameters.append([
            "key": "sid",
            "value": sid,
            "type": "text"
        ])

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"] ?? ""
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                let paramType = param["type"] as? String ?? ""
                if paramType == "text" {
                    let paramValue = param["value"] as? String ?? ""
                    body += "\r\n\r\n\(paramValue)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";

        printDebug("body=\(body)")

        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: tempelteUrl)!,timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


//        var cookies = ""

//        if (UserInfo.loggedInUser != nil){
//            if let loginCookie = UserDefaults.standard.value(forKey: "loginCookie") as? String{
//                cookies = loginCookie
//            }else{
//                cookies = "AT_R_STAGE_SESSID=cba8fbjvl52c316a4b24tuank4"
//            }
//        }else{
//            if let SearchResultCookie = UserDefaults.standard.value(forKey: "SearchResultCookie") as? String{
//                cookies = SearchResultCookie
//            }else{
//                cookies = "AT_R_STAGE_SESSID=cba8fbjvl52c316a4b24tuank4"
//            }
//        }

        
//        request.addValue(cookies, forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData

        let requestDate = Date.getCurrentDate()
        var textLog = TextLog()

        textLog.write("\n##########################################################################################\nAPI URL :::\(tempelteUrl)")

        textLog.write("\nREQUEST HEADER :::::::: \(requestDate)  ::::::::\n\n\(String(describing: request.allHTTPHeaderFields))\n")
        textLog.write("\nParameters :::::::: \(requestDate)  ::::::::\n\n\(parameters)\n")

        AppNetworking.addCookies(forUrl: request.url, from: "GetSharableUrl")

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                printDebug(String(describing: error))
                return
            }

            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject

                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject]
                    {
                        textLog.write("RESPONSE DATA ::::::::    \(Date.getCurrentDate()) ::::::::\(result)\n##########################################################################################\n")
                        
                        AppNetworking.saveCookies(fromUrl: response?.url, from: "GetSharableUrl")

                        if result["success"] as? Bool == true{
                            if let data = (result["data"] as? [String:Any]){
                                if let view = data["view"] as? String{
                                    self.delegate?.returnEmailView(view: view)
                                }
                            }
                        }else{
                            if let errors = result["errors"] as? [String]{
                                self.delegate?.returnEmailView(view: errors.first ?? "")
                            }
                        }
                    }
                }
            }catch{
            }
            self.semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    func getReturnDate(journey:[Journey])->String{
        var showDate = Date()
        var returnDate = ""
        let inputFormatter = DateFormatter()
        
        if tripType == "single"{
            returnDate.append("return=&")
        }else if tripType == "return"{
            if self.searchParam.count > 0{
                returnDate.append("return=\(searchParam["return"] ?? "")&")
            }else{
                returnDate.append("return=&")
            }
        }else{
            for i in 0..<journey.count{
                
                inputFormatter.dateFormat = "yyyy-MM-dd"
                if let date = inputFormatter.date(from: journey[i].dd){
                    showDate = date
                }
                inputFormatter.dateFormat = "dd-MM-yyyy"
                let newDd = inputFormatter.string(from: showDate)
                returnDate.append("return[\(i)]=\(newDd)&")
            }
        }
        
        return returnDate
    }
    
    func getDepartureDate(journey:[Journey])->String{
        var departureDate = ""

        if tripType == "single" || tripType == "return"{
            if self.searchParam.count > 0{
                departureDate.append("depart=\(searchParam["depart"] ?? "")&")
            }
        }else{
            let depart = searchParam.filter { $0.key.contains("depart") }
            
            for i in 0..<depart.count{
                departureDate.append("depart[\(i)]=\(searchParam["depart[\(i)]"] ?? "")&")
            }
        }
        
        return departureDate
    }
    
    func getOrigin(journey:[Journey])->String
    {
        var origin = ""
        if tripType == "single" || tripType == "return"{
//            origin.append("origin=\(journey[0].ap[0])&")
            
            origin.append("origin=\(searchParam["origin"] ?? "")&")
            origin = origin.replacingOccurrences(of: " ", with: "")
        }else{
            let originCount = searchParam.filter { $0.key.contains("origin") }
            
            for i in 0..<originCount.count{
                origin.append("origin[\(i)]=\(searchParam["origin[\(i)]"] ?? "")&")
            }
        }
        
        return origin
    }
    
    func getDestination(journey:[Journey])->String{
        var destination = ""
        if tripType == "single" || tripType == "return"{
//            destination.append("destination=\(journey[0].ap[1])&")
            
            destination.append("destination=\(searchParam["destination"] ?? "")&")
            destination = destination.replacingOccurrences(of: " ", with: "")
        }else{
            let destinations = searchParam.filter { $0.key.contains("destination") }
            
            for i in 0..<destinations.count{
                destination.append("destination[\(i)]=\(searchParam["destination[\(i)]"] ?? "")&")
            }
        }
        
        return destination
    }
    
    func getPinnedFlightFK(journey:[Journey])->String{
        var pinnedFlightFK = ""
        
        for i in 0..<journey.count{
            if i == journey.count-1{
                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)")
            }else{
                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)&")
            }
        }
        
        return pinnedFlightFK
    }
    
    
    //    MARK:- get user applied filters for domestic journey
    
    func getAppliedFiltersForSharingDomesticJourney(legs:[FlightResultDisplayGroup], isConditionReverced:Bool)->String
    {
        var filterString = ""
        
        for i in 0..<legs.count{
            filterString.append("&")
            let userSelectedFilters = legs[i].userSelectedFilters
            
            let appliedFilters = legs[i].appliedFilters
            let appliedSubFilters = legs[i].appliedSubFilters
            let uiFilters = legs[i].UIFilters
            let dynamicFilters = legs[i].dynamicFilters
          
            
            //            quality
            var fqArray = [String]()
            
            if uiFilters.contains(.hideOvernightLayover){
                fqArray.append("ovgtlo")
            }
            
            if uiFilters.contains(.hideOvernight){
                fqArray.append("ovgtf")
            }
            
            if uiFilters.contains(.hideChangeAirport){
                fqArray.append("coa")
            }
            
            if uiFilters.contains(.hideLongerOrExpensive){
                fqArray.append("aht")
            }
            
            var quality = ""
            
            if fqArray.count > 0{
                for n in 0..<fqArray.count{
                    quality.append("filters[\(i)][fq][\(n)]=\(fqArray[n])&")
                }
                filterString.append(quality)
            }
            
            //Aircraft
            if dynamicFilters.aircraft.selectedAircraftsArray.count > 0{
                var aircraft = ""
                for n in 0..<dynamicFilters.aircraft.selectedAircraftsArray.count{
                    aircraft.append("filters[\(i)][eq][\(n)]=\(dynamicFilters.aircraft.selectedAircraftsArray[n].code)&")
                }
                
                filterString.append(aircraft)
            }
            
            //isConditionReverced - true= desc & false = asc(lowto high/earlist first)
            //Sort
            if legs[i].sortOrder == .Smart{
                filterString.append("sort[]=humane-sorting_asc&")
            }
            
            if legs[i].sortOrder == .Price{
                if isConditionReverced{
                    filterString.append("sort[]=price-sorting_desc&")
                }else{
                    filterString.append("sort[]=price-sorting_asc&")
                }
            }
            
            if legs[i].sortOrder == .Duration{
                if isConditionReverced{
                    filterString.append("sort[]=duration-sorting_desc&")
                }else{
                    filterString.append("sort[]=duration-sorting_asc&")
                }
            }
            
            if legs[i].sortOrder == .Depart{
                if isConditionReverced{
                    filterString.append("sort[]=depart-sorting_desc&")
                }else{
                    filterString.append("sort[]=depart-sorting_asc&")
                }
            }
            
            if legs[i].sortOrder == .Arrival{
                if isConditionReverced{
                    filterString.append("sort[]=arrive-sorting_desc&")
                }else{
                    filterString.append("sort[]=arrive-sorting_asc&")
                }
            }
            
            
            //     Times
            if (appliedFilters.contains(.Times))
            {
                
                //     Departure Time
                if appliedSubFilters.contains(.departureTime){
                    var depTime = ""
                    if let earliest = userSelectedFilters?.dt.earliest{
                        if let earliestTimeInverval = convertFrom(string: earliest){
                            let intTime = Int(earliestTimeInverval/60)
                            depTime.append("filters[\(i)][dep_dt][0]=\(intTime)&")
                        }
                    }
                    
                    if let latest = userSelectedFilters?.dt.latest{
                        if let latestTimeInverval = convertFrom(string: latest){
                            let intTime = Int(latestTimeInverval/60)
                            depTime.append("filters[\(i)][dep_dt][1]=\(intTime)")
                        }
                    }
                    
                    filterString.append("\(depTime)&")
                }
                
                
                
                //     Arrival Time
                if appliedSubFilters.contains(.arrivalTime){
                    var arrivalTime = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    var earlistDate = Date()
                    var latestDate = Date()
                    
                    if let arrivalDateEarliest = userSelectedFilters?.arDt.earliest
                    {
                        let earliest = arrivalDateEarliest.components(separatedBy: " ")
                        var earliestTimeInverval = TimeInterval()
                        if earliest.count > 1{
                            if let date = convertFrom(string: earliest[1]){
                                earliestTimeInverval = date
                            }
                            
                            if let date = dateFormatter.date(from:earliest[0]){
                                earlistDate = date
                            }
                            
                        }else{
                            if let date = convertFrom(string: earliest[0]){
                                earliestTimeInverval = date
                            }
                        }
                        let intTime = Int(earliestTimeInverval/60)
                        arrivalTime.append("filters[\(i)][ar_dt][0]=\(intTime)&")
                    }
                    
                    
                    
                    if let arrivalDateLatest = userSelectedFilters?.arDt.latest
                    {
                        let latest = arrivalDateLatest.components(separatedBy: " ")
                        if let date = dateFormatter.date(from:latest[0]){
                            latestDate = date
                        }
                        
                        let dayHourMinuteSecond: Set<Calendar.Component> = [.day]
                        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: earlistDate, to: latestDate)
                        
                        let day = difference.day ?? 0
                        
                        if day > 0{
                            
                            //Add 1440 to time to add 24 hours
                            let newDay = 1440*day
                            if let latestTimeInverval = convertFrom(string: latest[1]){
                                var intTime = Int(latestTimeInverval/60)
                                intTime = intTime+newDay
                                arrivalTime.append("filters[\(i)][ar_dt][1]=\(intTime)&")
                            }
                        }else{
                            if let latestTimeInverval = convertFrom(string: latest[1]){
                                let intTime = Int(latestTimeInverval/60)
                                arrivalTime.append("filters[\(i)][ar_dt][1]=\(intTime)&")
                            }
                        }
                    }
                    
                    filterString.append("\(arrivalTime)")
                }
            }
            
            
            //     Duration
            if (appliedFilters.contains(.Duration))
            {
                //     Trip Duration
                
                if appliedSubFilters.contains(.tripDuration){
                    var tripDuration = ""
                    if let tripMinTime = Int(userSelectedFilters?.tt.minTime ?? "0"){
                        let minTime = tripMinTime/3600
                        tripDuration.append("filters[\(i)][tt][0]=\(minTime)&")
                    }
                    if let tripMaxTime = Int(userSelectedFilters?.tt.maxTime ?? "0"){
                        let maxTime = tripMaxTime/3600
                        tripDuration.append("filters[\(i)][tt][1]=\(maxTime)")
                    }
                    
                    filterString.append("\(tripDuration)&")
                    
                }
                
                //     Layover Duration
                if appliedSubFilters.contains(.layoverDuration){
                    var layoverDuration = ""
                    if let layoverMinTime = Int(userSelectedFilters?.lott?.minTime ?? "0"){
                        let minTime = layoverMinTime/3600
                        layoverDuration.append("filters[\(i)][lott][0]=\(minTime)&")
                    }
                    
                    if let layoverMaxTime = Int(userSelectedFilters?.lott?.maxTime ?? "0"){
                        let maxTime = layoverMaxTime/3600
                        layoverDuration.append("filters[\(i)][lott][1]=\(maxTime)&")
                    }
                    
                    filterString.append("\(layoverDuration)")
                }
            }
            
            
            //     Airline
            if (appliedFilters.contains(.Airlines))
            {
                var airline = ""
                if let airlines = userSelectedFilters?.al{
                    for n in 0..<airlines.count{
                        airline.append("filters[\(i)][al][\(n)]=\(airlines[n])&")
                    }
                }
                filterString.append(airline)
            }
            
            
            //     Airport
            if (appliedFilters.contains(.Airport))
            {
                var airport = ""
                
                if uiFilters.contains(.layoverAirports){
                    if let loap = userSelectedFilters?.loap{
                        for n in 0..<loap.count{
                            airport.append("filters[\(i)][loap][\(n)]=\(loap[n])&")
                        }
                    }
                }else{
                    var airportsArray = [String]()
                    if let to = userSelectedFilters?.cityapN.to{
                        if let destinationAirport = to.values.first{
                            airportsArray.append(contentsOf: destinationAirport)
                        }
                    }
                    
                    if let fr = userSelectedFilters?.cityapN.fr{
                        if let originAirport = fr.values.first{
                            airportsArray.append(contentsOf: originAirport)
                        }
                    }
                    
                    for n in 0..<airportsArray.count{
                        airport.append("filters[\(i)][ap][\(n)]=\(airportsArray[n])&")
                    }
                }
                
                filterString.append(airport)
            }
            
            //     Quality
            if (appliedFilters.contains(.Quality))
            {
                var quality = ""
                
                if let fq = userSelectedFilters?.fq{
                    let fqArray = Array(fq.keys)
                    for n in 0..<fqArray.count{
                        quality.append("filters[\(i)][fq][\(n)]=\(fqArray[n])&")
                    }

                }
                
                filterString.append(quality)
            }
            
            
            //     Price
            if (appliedFilters.contains(.Price))
            {
                if let pr = userSelectedFilters?.pr, legs[i].initiatedFilters.contains(.price) {
                    let price = "filters[\(i)][pr][0]=\(pr.minPrice)&filters[\(i)][pr][1]=\(pr.maxPrice)&"

                    filterString.append(price)
                }
                
                if uiFilters.contains(.refundableFares){
                    filterString.append("filters[\(i)][fares][]=1&")
                    
                }
            }
            
            
            //     Stops
            if (appliedFilters.contains(.stops))
            {
                var stops = ""
                
                if let stp = userSelectedFilters?.stp{
                    for n in 0..<stp.count{
                        if n == stp.count-1{
                            stops.append("filters[\(i)][stp][\(n)]=\(stp[n])")
                        }else{
                            stops.append("filters[\(i)][stp][\(n)]=\(stp[n])&")
                        }
                    }
                }
                
                filterString.append(stops)
            }
        }
        
        return filterString
    }
    
    //    MARK:- get user applied filters for international journey
    
    func getAppliedFiltersForSharingIntJourney(legs:[IntFlightResultDisplayGroup],isConditionReverced:Bool,appliedFilterLegIndex:Int)->String
    {
        var filterString = ""
        
        if legs.count > 0{
            let userSelectedFilters = legs[0].userSelectedFilters
            let appliedFilters = legs[0].appliedFilters
            let appliedSubFilters = legs[0].appliedSubFilters
            let uiFilters = legs[0].UIFilters
            let dynamicFilters = legs[0].dynamicFilters
            let numberOfLegs = legs[0].numberOfLegs
                        
            for i in 0..<userSelectedFilters.count
            {
                filterString.append("")
                
                //Quality
                var fqArray = [String]()
                
//                print("uiFilters=",uiFilters)
                if uiFilters.contains(.hideOvernightLayover){
                    fqArray.append("ovgtlo")
                }
                
                if uiFilters.contains(.hideOvernight){
                    fqArray.append("ovgtf")
                }
                
                if uiFilters.contains(.hideChangeAirport){
                    fqArray.append("coa")
                }
                
                if uiFilters.contains(.hideLongerOrExpensive){
                    fqArray.append("aht")
                }
                
                var quality = ""
                
                if fqArray.count > 0{
                    for n in 0..<fqArray.count{
                        quality.append("&filters[\(i)][fq][\(n)]=\(fqArray[n])")
                    }
                    filterString.append(quality)
                }
                
//                print("filterString=",filterString)
                
                //     Times
                if (appliedFilters.contains(.Times))
                {
                    //     Departure Time
                    if (appliedSubFilters[0]?.contains(.departureTime) ?? false){
                        var depTime = ""
                        let earliest = userSelectedFilters[i].dt.earliest
                        if let earliestTimeInverval = convertFrom(string: earliest){
                            let intEarliestTime = Int(earliestTimeInverval/60)
                            depTime.append("&filters[\(i)][dep_dt][0]=\(intEarliestTime)")
                        }
                        
                        
                        let latest = userSelectedFilters[i].dt.latest
                        if let latestTimeInverval = convertFrom(string: latest){
                            let intLatestTime = Int(latestTimeInverval/60)
                            depTime.append("&filters[\(i)][dep_dt][1]=\(intLatestTime)")
                        }
                        
                        filterString.append("\(depTime)")
                        
                    }
                    
                    
                    //     Arrival Time
                    
                    if (appliedSubFilters[0]?.contains(.arrivalTime) ?? false)
                    {
                        var arrivalTime = ""
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        var earlistDate = Date()
                        var latestDate = Date()
                        
                        let arrivalDateEarliest = userSelectedFilters[i].arDt.earliest
                        let earliestArrival = arrivalDateEarliest.components(separatedBy: " ")
                        if let date = dateFormatter.date(from:earliestArrival[0]){
                            earlistDate = date
                        }
                        if let earliestArrivalTimeInverval = convertFrom(string: earliestArrival[1]){
                            let intArrivalTime = Int(earliestArrivalTimeInverval/60)
                            arrivalTime.append("&filters[\(i)][ar_dt][0]=\(intArrivalTime)")
                        }
                        
                        
                        let arrivalDateLatest = userSelectedFilters[i].arDt.latest
                        
                        let latestArrival = arrivalDateLatest.components(separatedBy: " ")
                        if let date = dateFormatter.date(from:latestArrival[0]){
                            latestDate = date
                        }
                        
                        let dayHourMinuteSecond: Set<Calendar.Component> = [.day]
                        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: earlistDate, to: latestDate)
                        
                        let day = difference.day ?? 0
                        
                        if day > 0{
                            
                            //Add 1440 to time to add 24 hours
                            let newDay = 1440*day
                            if let latestTimeInverval = convertFrom(string: latestArrival[1]){
                                var intTime = Int(latestTimeInverval/60)
                                intTime = intTime+newDay
                                arrivalTime.append("&filters[\(i)][ar_dt][1]=\(intTime)")
                            }
                        }else{
                            if let latestTimeInverval = convertFrom(string: latestArrival[1]){
                                let intTime = Int(latestTimeInverval/60)
                                arrivalTime.append("&filters[\(i)][ar_dt][1]=\(intTime)")
                            }
                        }
                        
                        filterString.append("\(arrivalTime)")
                        
                    }
                    
                    
                }
                
                
                //     Duration
                if (appliedFilters.contains(.Duration))
                {
                    //     Trip Duration
                    if (appliedSubFilters[0]?.contains(.tripDuration) ?? false)
                    {
                        var tripDuration = ""
                        if let tripMinTime = Int(userSelectedFilters[i].tt.minTime ?? "0"){
                            let minTime = tripMinTime/3600
                            tripDuration.append("&filters[\(i)][tt][0]=\(minTime)")
                        }
                        if let tripMaxTime = Int(userSelectedFilters[i].tt.maxTime ?? "0"){
                            let maxTime = tripMaxTime/3600
                            tripDuration.append("&filters[\(i)][tt][1]=\(maxTime)")
                        }
                        filterString.append("\(tripDuration)")
                    }
                    
                    
                    
                    //     Layover Duration
                    if (appliedSubFilters[0]?.contains(.layoverDuration) ?? false)
                    {
                        var layoverDuration = ""
                        if let layoverMinTime = Int(userSelectedFilters[i].lott.minTime ?? "0"){
                            let minTime = layoverMinTime/3600
                            layoverDuration.append("&filters[\(i)][lott][0]=\(minTime)")
                        }
                        
                        if let layoverMaxTime = Int(userSelectedFilters[i].lott.maxTime ?? "0"){
                            let maxTime = layoverMaxTime/3600
                            layoverDuration.append("&filters[\(i)][lott][1]=\(maxTime)")
                        }
                        
                        filterString.append("\(layoverDuration)")
                    }
                }
                
                
                //     Airline
                if (appliedFilters.contains(.Airlines))
                {
                    var airline = ""
                    for n in 0..<userSelectedFilters[0].al.count{
                        airline.append("&filters[\(i)][al][\(n)]=\(userSelectedFilters[0].al[n])")
                    }
                    
                    
                    
                    
                    filterString.append(airline)
                }
                
                
                //     Airport
                if (appliedFilters.contains(.Airport))
                {
                    var airport = ""
                    
                    for n in 0..<userSelectedFilters[i].loap.count{
                        airport.append("&filters[\(i)][loap][\(n)]=\(userSelectedFilters[i].loap[n])")
                    }
                    
                    filterString.append(airport)
                }
                
                //     Airport - originDestinationSelectedForReturnJourney
                
                if uiFilters.contains(.originDestinationSelectedForReturnJourney) {
                    var airport = ""
                    let selectedAp = Array(Set(userSelectedFilters[0].cityapn.returnOriginAirports + userSelectedFilters[0].cityapn.returnDestinationAirports))
                    
                    for n in 0..<selectedAp.count{
                        airport.append("&filters[\(i)][ap][\(n)]=\(selectedAp[n])")
                    }
                    
                    filterString.append(airport)
                    
                } else if ((appliedSubFilters[i]?.contains(.originAirports) ?? false) || (appliedSubFilters[i]?.contains(.destAirports)) ?? false) {
                    
                    var airport = ""
                    var airportsArray = [String]()
                    
                    let fr = userSelectedFilters[i].cityapn.fr
                    let to = userSelectedFilters[i].cityapn.to
                    
                    airportsArray.append(contentsOf: fr.flatMap { $0.value } )
                    airportsArray.append(contentsOf: to.flatMap { $0.value } )
                    airportsArray = Array(Set(airportsArray))
                    
                    for n in 0..<airportsArray.count{
                        airport.append("&filters[\(i)][ap][\(n)]=\(airportsArray[n])")
                    }
                    
                    filterString.append(airport)
                }
                

//                if uiFilters.contains(.originDestinationSelectedForReturnJourney)
//                {
//                    var airport = ""
//                    var airportsArray = [String]()
//
//                    let returnOriginAirports = userSelectedFilters[i].cityapn.returnOriginAirports
//
//                    if returnOriginAirports.count > 0{
//
//                        for i in 0..<returnOriginAirports.count{
//                            airportsArray.append(returnOriginAirports[i])
//                        }
//                    }else{
//                        let fr = userSelectedFilters[i].cityapn.fr
//
//                        if let originAirport = fr.values.first{
//                            airportsArray.append(contentsOf: originAirport)
//                        }
//                    }
//
//
//
//
//                    let returnDestinationAirports = userSelectedFilters[i].cityapn.returnDestinationAirports
//                    if returnDestinationAirports.count > 0 {
//                        for i in 0..<returnDestinationAirports.count{
//                            airportsArray.append(returnDestinationAirports[i])
//                        }
//                    }else{
//                        let to = userSelectedFilters[i].cityapn.to
//
//                        if let destinationAirport = to.values.first{
//                            airportsArray.append(contentsOf: destinationAirport)
//                        }
//                    }
//
//
//                    for n in 0..<airportsArray.count{
//                        airport.append("&filters[\(i)][ap][\(n)]=\(airportsArray[n])")
//                    }
//
//                    filterString.append(airport)
//
//                }
                
                
                
                //     Quality
                if (appliedFilters.contains(.Quality))
                {
                    var quality = ""
                    
                    let fqArray = Array(userSelectedFilters[i].fq.keys)
                    for n in 0..<fqArray.count{
                        quality.append("&filters[\(i)][fq][\(n)]=\(fqArray[n])")
                    }
                    
                    filterString.append(quality)
                }
                
                
                //     Stops
                if (appliedFilters.contains(.stops))
                {
                    var stops = ""
                    
                    for n in 0..<userSelectedFilters[i].stp.count{
//                        if n == userSelectedFilters[i].stp.count-1{
                            stops.append("&filters[\(i)][stp][\(n)]=\(userSelectedFilters[i].stp[n])")
//                        }else{
//                            stops.append("filters[\(i)][stp][\(n)]=\(userSelectedFilters[i].stp[n])&")
//                        }
                    }
                    
                    filterString.append(stops)
                }
            }
            
            
            //     Price
            if (appliedFilters.contains(.Price))
            {
                if legs[0].initiatedFilters[0]?.contains(.price) ?? false {
                    
                    let price = "&filters[\(appliedFilterLegIndex)][pr][0]=\(userSelectedFilters[appliedFilterLegIndex].pr.minPrice)&filters[\(appliedFilterLegIndex)][pr][1]=\(userSelectedFilters[appliedFilterLegIndex].pr.maxPrice)"
                    
                    filterString.append(price)
                    
                }
            }
            
            //Aircraft
            if dynamicFilters.aircraft.selectedAircraftsArray.count > 0{
                var aircraft = ""
                for n in 0..<dynamicFilters.aircraft.selectedAircraftsArray.count{
                    aircraft.append("&filters[0][eq][\(n)]=\(dynamicFilters.aircraft.selectedAircraftsArray[n].code)")
                }
                
                filterString.append(aircraft)
            }
            
//            Example - Applied departure sort to DXB i.e. for 2nd leg so sort will be share as sort[]=depart-sorting_asc & for other 2 it will be empty as sort[]=
//            https://beta.aertrip.com/flights?trip_type=multi&adult=1&child=0&infant=0&origin[]=BOM&origin[]=DXB&origin[]=DEL&destination[]=DXB&destination[]=DEL&destination[]=BOM&depart[]=04-11-2020&depart[]=05-11-2020&depart[]=06-11-2020&return=04-11-2020&cabinclass=Economy&pType=flight&isDomestic=false&PF[]=4f954a946c599e1d04b703dcee38ab72~f9b57244b44a50eee292513b5698b341~c585b8d58885d758acb516adaea93474&sort[]=&sort[]=depart-sorting_asc&sort[]=
            

            //isConditionReverced - true= desc & false = asc(lowto high/earlist first)
            //Sort
            if legs[0].sortOrder == .Smart{
                filterString.append("&sort[]=humane-sorting_asc")
            }

            if legs[0].sortOrder == .Price{
                if isConditionReverced{
                    filterString.append("&sort[]=price-sorting_desc")
                }else{
                    filterString.append("&sort[]=price-sorting_asc")
                }
            }

            if legs[0].sortOrder == .Duration{
                if isConditionReverced{
                    filterString.append("&sort[]=duration-sorting_desc")
                }else{
                    filterString.append("&sort[]=duration-sorting_asc")
                }
            }

            if legs[0].sortOrder == .Depart
            {
                for leg in 0..<numberOfLegs{
                    if leg == appliedFilterLegIndex{
                        if isConditionReverced{
                            filterString.append("&sort[]=depart-sorting_desc")
                        }else{
                            filterString.append("&sort[]=depart-sorting_asc")
                        }
                    }else{
                        filterString.append("&sort[]=")
                    }
                }
            }

            if legs[0].sortOrder == .Arrival
            {
                for leg in 0..<numberOfLegs{
                    if leg == appliedFilterLegIndex{
                        if isConditionReverced{
                            filterString.append("&sort[]=arrive-sorting_desc")
                        }else{
                            filterString.append("&sort[]=arrive-sorting_asc")
                        }
                    }else{
                        filterString.append("&sort[]=")
                    }
                }
                
            }
        }
        
        return filterString
    }
    
    func convertFrom(string : String) ->  TimeInterval? {
        
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
}

extension URL
{
    func expandURLWithCompletionHandler(completionHandler: @escaping (URL?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: self, completionHandler: {
            _, response, _ in
            if let expandedURL = response?.url {
                completionHandler(expandedURL)
            }
        })
        dataTask.resume()
    }
}

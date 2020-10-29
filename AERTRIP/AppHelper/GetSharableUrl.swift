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
            
            valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)\(filterString)"
            
            print("valueString=",valueString)
        }
        
        let pinnedUrl = flightBaseUrl+"get-pinned-url"
        var parameters = [[String : Any]]()
        if isInternational{
            parameters = [
                [
                    "key": "u",
                    "value": valString,
                    "type": "text"
                ]] as [[String : Any]]
        }else{
            parameters = [
                [
                    "key": "u",
                    "value": valueString,
                    "type": "text"
                ]] as [[String : Any]]
        }
        
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                        + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: pinnedUrl)!,timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        request.addValue("AT_R_STAGE_SESSID=cba8fbjvl52c316a4b24tuank4", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            print(String(data: data, encoding: .utf8)!)
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if result["success"] as? Bool == true{
                            
                            if let data = (result["data"] as? [String:Any]){
                                if let link = data["u"] as? String{
                                    self.delegate?.returnSharableUrl(url: link)
                                }
                            }
                        }else{
                            self.delegate?.returnSharableUrl(url: "No Data")
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
    
    
    
    func getUrlForMail(adult:String, child:String, infant:String,isDomestic:Bool, sid:String, isInternational:Bool, journeyArray:[Any],valString:String, trip_type:String)
    {
        tripType = trip_type
        let tempelteUrl = flightBaseUrl+"get-pinned-template"
        
        var valueString = ""
        if !isInternational{
            let cc = (journeyArray as! [Journey]).first!.cc
            let origin = getOrigin(journey: (journeyArray as! [Journey]))
            let destination = getDestination(journey: (journeyArray as! [Journey]))
            let departureDate = getDepartureDate(journey: (journeyArray as! [Journey]))
            let returnDate = getReturnDate(journey: (journeyArray as! [Journey]))
            let pinnedFlightFK = getPinnedFlightFK(journey: (journeyArray as! [Journey]))
            
            
            valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)"
        }
        
        var parameters = [[String : Any]]()
        for i in 0..<journeyArray.count{
            if isInternational{
                let test = [
                    "key": "fk[\(i)]",
                    "value": (journeyArray as! [IntMultiCityAndReturnWSResponse.Results.J])[i].fk,
                    "type": "text"
                ]
                
                parameters.append(test)
            }else{
                let test = [
                    "key": "fk[\(i)]",
                    "value": (journeyArray as! [Journey])[i].fk,
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
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                        + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        
        print("body= ",body)
        
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: tempelteUrl)!,timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var cookies = ""
        if let allCookies = UserDefaults.getCustomObject(forKey: UserDefaults.Key.currentUserCookies.rawValue) as? [HTTPCookie]
        {
            print("allCookies")
            if allCookies.count > 0{
                let name = allCookies.first?.name ?? ""
                let value = allCookies.first?.value ?? ""
                cookies = name + "=" + value
            }
        }
        
        print("cookies= ",cookies)
        request.addValue(cookies, forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        
        print("postData=", String(data: postData!, encoding: .utf8)!)

//        print("request= ",request.allHTTPHeaderFields)
        
        let requestDate = Date.getCurrentDate()
        var textLog = TextLog()

        textLog.write("\n##########################################################################################\nAPI URL :::\(tempelteUrl)")

        textLog.write("\nREQUEST HEADER :::::::: \(requestDate)  ::::::::\n\n\(String(describing: request.allHTTPHeaderFields))\n")
        textLog.write("\nParameters :::::::: \(requestDate)  ::::::::\n\n\(parameters)\n")

        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject]
                    {
                        textLog.write("RESPONSE DATA ::::::::    \(Date.getCurrentDate()) ::::::::\(result)\n##########################################################################################\n")

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
//            if journey.count == 2{
//                inputFormatter.dateFormat = "yyyy-MM-dd"
//                showDate = inputFormatter.date(from: journey[1].dd)!
//                inputFormatter.dateFormat = "dd-MM-yyyy"
//                let newDd = inputFormatter.string(from: showDate)
//                returnDate.append("return=\(newDd)&")
//            }else{
                if self.searchParam.count > 0{
                    returnDate.append("return=\(searchParam["return"] ?? "")&")
                }else{
                    returnDate.append("return=&")
                }
//                returnDate.append("return=\(returnDateForJourney)&")
//            }
        }else{
            
            for i in 0..<journey.count{

                inputFormatter.dateFormat = "yyyy-MM-dd"
                showDate = inputFormatter.date(from: journey[i].dd)!
                inputFormatter.dateFormat = "dd-MM-yyyy"
                let newDd = inputFormatter.string(from: showDate)
                returnDate.append("return[\(i)]=\(newDd)&")
            }
            
            
//            let origin = searchParam.filter { $0.key.contains("origin") }
//
//            for i in 0..<origin.count{
//                returnDate.append("return[\(i)]=\(searchParam["depart[\(i)]"] ?? "")&")
//            }
            
//            returnDate.append("return=&")
            
        }
        
        
        
        return returnDate
    }
    
    func getDepartureDate(journey:[Journey])->String{
        var departureDate = ""
        let inputFormatter = DateFormatter()
        var showDate = Date()
        
        if tripType == "single" || tripType == "return"{
            if self.searchParam.count > 0{
                departureDate.append("depart=\(searchParam["depart"] ?? "")&")
            }else{
                departureDate.append("depart=&")
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
            origin.append("origin=\(journey[0].ap[0])&")
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
            destination.append("destination=\(journey[0].ap[1])&")
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
    
    
    func getAppliedFiltersForSharingDomesticJourney(legs:[FlightResultDisplayGroup])->String
    {
        var filterString = ""
        
        for i in 0..<legs.count{
            filterString.append("&")
            let userSelectedFilters = legs[i].userSelectedFilters
            
            let appliedFilters = legs[i].appliedFilters
            let appliedSubFilters = legs[i].appliedSubFilters
            let uiFilters = legs[i].UIFilters
            
            print("appliedFilters=",appliedFilters)
            print("uiFilters=",uiFilters)

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
            
            
            //     Times
            if (appliedFilters.contains(.Times))
            {
                
                //     Departure Time
                if appliedSubFilters.contains(.departureTime){
                    var depTime = ""
                    if let earliest = userSelectedFilters?.dt.earliest{
                        let earliestTimeInverval = convertFrom(string: earliest)
                        let intTime = Int(earliestTimeInverval!/60)
                        depTime.append("filters[\(i)][dep_dt][0]=\(intTime)&")
                    }
                    
                    if let latest = userSelectedFilters?.dt.latest{
                        let latestTimeInverval = convertFrom(string: latest)
                        let intTime = Int(latestTimeInverval!/60)
                        depTime.append("filters[\(i)][dep_dt][1]=\(intTime)")
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
                            earliestTimeInverval = convertFrom(string: earliest[1])!
                                                        
                            if let date = dateFormatter.date(from:earliest[0]){
                                earlistDate = date
                            }
                            
                        }else{
                            earliestTimeInverval = convertFrom(string: earliest[0])!
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
                    if let tripMinTime = Int(userSelectedFilters!.tt.minTime!){
                        let minTime = tripMinTime/3600
                        tripDuration.append("filters[\(i)][tt][0]=\(minTime)&")
                    }
                    if let tripMaxTime = Int(userSelectedFilters!.tt.maxTime!){
                        let maxTime = tripMaxTime/3600
                        tripDuration.append("filters[\(i)][tt][1]=\(maxTime)")
                    }
                    
                    filterString.append("\(tripDuration)&")
                    
                }
                
                //     Layover Duration
                if appliedSubFilters.contains(.layoverDuration){
                    var layoverDuration = ""
                    if let layoverMinTime = Int(userSelectedFilters!.lott!.minTime!){
                        let minTime = layoverMinTime/3600
                        layoverDuration.append("filters[\(i)][lott][0]=\(minTime)&")
                    }
                    
                    if let layoverMaxTime = Int(userSelectedFilters!.lott!.maxTime!){
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
                for n in 0..<userSelectedFilters!.al.count{
                    airline.append("filters[\(i)][al][\(n)]=\(userSelectedFilters!.al[n])&")
                }
                
                filterString.append(airline)
            }
            
            
            //     Airport
            if (appliedFilters.contains(.Airport))
            {
                var airport = ""
                for n in 0..<userSelectedFilters!.loap.count{
                    airport.append("filters[\(i)][loap][\(n)]=\(userSelectedFilters!.loap[n])&")
                }
                
                filterString.append(airport)
            }
            
            //     Quality
            if (appliedFilters.contains(.Quality))
            {
                var quality = ""
                
                let fqArray = Array(userSelectedFilters!.fq.keys)
                for n in 0..<fqArray.count{
                    quality.append("filters[\(i)][fq][\(n)]=\(fqArray[n])&")
                }
                
                filterString.append(quality)
            }
            
            
            //     Price
            if (appliedFilters.contains(.Price))
            {
                let price = "filters[\(i)][pr][0]=\(userSelectedFilters!.pr.minPrice)&filters[\(i)][pr][1]=\(userSelectedFilters!.pr.maxPrice)&"
                
                filterString.append(price)
            }
            
            
            //     Stops
            if (appliedFilters.contains(.stops))
            {
                var stops = ""
                
                for n in 0..<userSelectedFilters!.stp.count{
                    if n == userSelectedFilters!.stp.count-1{
                        stops.append("filters[\(i)][stp][\(n)]=\(userSelectedFilters!.stp[n])")
                    }else{
                        stops.append("filters[\(i)][stp][\(n)]=\(userSelectedFilters!.stp[n])&")
                    }
                }
                
                filterString.append(stops)
            }
        }
        if filterString == "&" || filterString == "&&"{
            filterString = ""
        }
        
        return filterString
    }
    
    func getAppliedFiltersForSharingIntJourney(legs:[IntFlightResultDisplayGroup])->String
    {
        var filterString = ""
        
        if legs.count > 0{
            let userSelectedFilters = legs[0].userSelectedFilters
            let appliedFilters = legs[0].appliedFilters
            let appliedSubFilters = legs[0].appliedSubFilters
            let uiFilters = legs[0].UIFilters

            for i in 0..<userSelectedFilters.count
            {
                filterString.append("&")
                
                //Quality
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
                
                
                
                //     Times
                if (appliedFilters.contains(.Times))
                {
                    //     Departure Time
                    if ((appliedSubFilters[0]?.contains(.departureTime)) != nil){
                        var depTime = ""
                        let earliest = userSelectedFilters[i].dt.earliest
                        let earliestTimeInverval = convertFrom(string: earliest)
                        let intEarliestTime = Int(earliestTimeInverval!/60)
                        depTime.append("filters[\(i)][dep_dt][0]=\(intEarliestTime)&")
                        
                        
                        let latest = userSelectedFilters[i].dt.latest
                        let latestTimeInverval = convertFrom(string: latest)
                        let intLatestTime = Int(latestTimeInverval!/60)
                        depTime.append("filters[\(i)][dep_dt][1]=\(intLatestTime)")

                        filterString.append("\(depTime)&")

                    }
                    
                    
                    //     Arrival Time

                    if ((appliedSubFilters[0]?.contains(.arrivalTime)) != nil)
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
                        let earliestArrivalTimeInverval = convertFrom(string: earliestArrival[1])
                        let intArrivalTime = Int(earliestArrivalTimeInverval!/60)
                        arrivalTime.append("filters[\(i)][ar_dt][0]=\(intArrivalTime)&")
                        
                        
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
                                    arrivalTime.append("filters[\(i)][ar_dt][1]=\(intTime)&")
                                }
                            }else{
                                if let latestTimeInverval = convertFrom(string: latestArrival[1]){
                                    let intTime = Int(latestTimeInverval/60)
                                    arrivalTime.append("filters[\(i)][ar_dt][1]=\(intTime)&")
                                }
                            }
                        
                        filterString.append("\(arrivalTime)&")

                    }
                    
                    
                }
                
                
                //     Duration
                if (appliedFilters.contains(.Duration))
                {
                    //     Trip Duration
                    if ((appliedSubFilters[0]?.contains(.tripDuration)) != nil)
                    {
                        var tripDuration = ""
                        if let tripMinTime = Int(userSelectedFilters[i].tt.minTime!){
                            let minTime = tripMinTime/3600
                            tripDuration.append("filters[\(i)][tt][0]=\(minTime)&")
                        }
                        if let tripMaxTime = Int(userSelectedFilters[i].tt.maxTime!){
                            let maxTime = tripMaxTime/3600
                            tripDuration.append("filters[\(i)][tt][1]=\(maxTime)")
                        }
                        filterString.append("\(tripDuration)&")
                    }
                    
                    
                    
                    //     Layover Duration
                    if ((appliedSubFilters[0]?.contains(.layoverDuration)) != nil)
                    {
                        var layoverDuration = ""
                        if let layoverMinTime = Int(userSelectedFilters[i].lott.minTime!){
                            let minTime = layoverMinTime/3600
                            layoverDuration.append("filters[\(i)][lott][0]=\(minTime)&")
                        }
                        
                        if let layoverMaxTime = Int(userSelectedFilters[i].lott.maxTime!){
                            let maxTime = layoverMaxTime/3600
                            layoverDuration.append("filters[\(i)][lott][1]=\(maxTime)&")
                        }
                        
                        filterString.append("\(layoverDuration)&")
                    }
                }
                
                
                //     Airline
                if (appliedFilters.contains(.Airlines))
                {
                    var airline = ""
                    for n in 0..<userSelectedFilters[i].al.count{
                        airline.append("filters[\(i)][al][\(n)]=\(userSelectedFilters[i].al[n])&")
                    }
                    
                    filterString.append(airline)
                }
                
                
                //     Airport
                if (appliedFilters.contains(.Airport))
                {
                    var airport = ""
                    for n in 0..<userSelectedFilters[i].loap.count{
                        airport.append("filters[\(i)][loap][\(n)]=\(userSelectedFilters[i].loap[n])&")
                    }
                    
                    filterString.append(airport)
                }
                
                //     Quality
                if (appliedFilters.contains(.Quality))
                {
                    var quality = ""
                    
                    let fqArray = Array(userSelectedFilters[i].fq.keys)
                    for n in 0..<fqArray.count{
                        quality.append("filters[\(i)][fq][\(n)]=\(fqArray[n])&")
                    }
                    
                    filterString.append(quality)
                }
                
                
                //     Price
                if (appliedFilters.contains(.Price))
                {
                    let price = "filters[\(i)][pr][0]=\(userSelectedFilters[i].pr.minPrice)&filters[\(i)][pr][1]=\(userSelectedFilters[i].pr.maxPrice)&"
                    
                    filterString.append(price)
                }
                
                
                //     Stops
                if (appliedFilters.contains(.stops))
                {
                    var stops = ""
                    
                    for n in 0..<userSelectedFilters[i].stp.count{
                        if n == userSelectedFilters[i].stp.count-1{
                            stops.append("filters[\(i)][stp][\(n)]=\(userSelectedFilters[i].stp[n])")
                        }else{
                            stops.append("filters[\(i)][stp][\(n)]=\(userSelectedFilters[i].stp[n])&")
                        }
                    }
                    
                    filterString.append(stops)
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


extension URL {
    
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

//
//  GetSharableUrl.swift
//  Aertrip
//
//  Created by Monika Sonawane on 31/07/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

protocol getSharableUrlDelegate : AnyObject {
    func returnSharableUrl(url:String)
    func returnEmailView(view:String)
}

import Foundation
import UIKit

class GetSharableUrl
{
    weak var delegate : getSharableUrlDelegate?
    var semaphore = DispatchSemaphore (value: 0)
    var tripType = ""
    
    func getUrl(adult:String, child:String, infant:String,isDomestic:Bool, isInternational:Bool, journeyArray:[Journey], valString:String,trip_type:String, filterString:String)
    {
        tripType = trip_type
        var valueString = ""
        if !isInternational{
            let cc = journeyArray.first!.cc
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
//                            if let link = (result["data"] as? [String:Any])?.value(forKey: "u") as? String{
//                                self.delegate?.returnSharableUrl(url: link)
//                            }
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
//            let trip_type = getTripType(journey: (journeyArray as! [Journey]))
            let origin = getOrigin(journey: (journeyArray as! [Journey]))
            let destination = getDestination(journey: (journeyArray as! [Journey]))
            let departureDate = getDepartureDate(journey: (journeyArray as! [Journey]))
            let returnDate = getReturnDate(journey: (journeyArray as! [Journey]))
            let pinnedFlightFK = getPinnedFlightFK(journey: (journeyArray as! [Journey]))
            
            valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)&cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)"
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
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: tempelteUrl)!,timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        request.addValue("AT_R_STAGE_SESSID=2vrftci1u2q2arn56d8fnap92c", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if result["success"] as? Bool == true{                            
                            if let data = (result["data"] as? [String:Any]){
                                if let view = data["view"] as? String{
                                    self.delegate?.returnEmailView(view: view)
                                }
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
    
//    func getTripType(journey:[Journey])->String{
//        if journey.count == 1{
//            return "single"
//        }else if journey.count > 2{
//            return "multi"
//        }else{
//            return "return"
//        }
//    }
    
    func getReturnDate(journey:[Journey])->String{
        var showDate = Date()
        var returnDate = ""
        let inputFormatter = DateFormatter()
        
        if tripType == "single"{
            returnDate.append("return=&")
        }else if tripType == "return"{
            inputFormatter.dateFormat = "yyyy-MM-dd"
            showDate = inputFormatter.date(from: journey[1].dd)!
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newDd = inputFormatter.string(from: showDate)
            returnDate.append("return=\(newDd)&")
        }else{
//            if journey.count == 1{
//                returnDate.append("return=&")
//            }else if journey.count > 2{
                for i in 0..<journey.count{

                    inputFormatter.dateFormat = "yyyy-MM-dd"
                    showDate = inputFormatter.date(from: journey[i].dd)!
                    inputFormatter.dateFormat = "dd-MM-yyyy"
                    let newDd = inputFormatter.string(from: showDate)
                    returnDate.append("return[\(i)]=\(newDd)&")
                }
//            }else{
//                inputFormatter.dateFormat = "yyyy-MM-dd"
//                showDate = inputFormatter.date(from: journey[1].dd)!
//                inputFormatter.dateFormat = "dd-MM-yyyy"
//                let newDd = inputFormatter.string(from: showDate)
//                returnDate.append("return=\(newDd)&")
//            }
        }
            
        

        return returnDate
    }
    
    func getDepartureDate(journey:[Journey])->String{
        var departureDate = ""
        let inputFormatter = DateFormatter()
        var showDate = Date()

        if tripType == "single" || tripType == "return"{
            inputFormatter.dateFormat = "yyyy-MM-dd"
            showDate = inputFormatter.date(from: journey[0].ad)!
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newAd = inputFormatter.string(from: showDate)
            departureDate.append("depart=\(newAd)&")
        }else{
//            if journey.count == 1{
//                inputFormatter.dateFormat = "yyyy-MM-dd"
//                showDate = inputFormatter.date(from: journey[0].ad)!
//                inputFormatter.dateFormat = "dd-MM-yyyy"
//                let newAd = inputFormatter.string(from: showDate)
//                departureDate.append("depart=\(newAd)&")
//
//            }else if journey.count > 2{
                for i in 0..<journey.count{
                    inputFormatter.dateFormat = "yyyy-MM-dd"
                    showDate = inputFormatter.date(from: journey[i].ad)!
                    inputFormatter.dateFormat = "dd-MM-yyyy"
                    let newAd = inputFormatter.string(from: showDate)
                    departureDate.append("depart[\(i)]=\(newAd)&")
                }
//            }else{
//                inputFormatter.dateFormat = "yyyy-MM-dd"
//                showDate = inputFormatter.date(from: journey[0].ad)!
//                inputFormatter.dateFormat = "dd-MM-yyyy"
//                let newAd = inputFormatter.string(from: showDate)
//                departureDate.append("depart=\(newAd)&")
//            }
        }
        
        return departureDate
    }
    
    func getOrigin(journey:[Journey])->String
    {
        var origin = ""
        if tripType == "single" || tripType == "return"{
            origin.append("origin=\(journey[0].ap[0])&")
        }else{
//            if journey.count == 1{
//                origin.append("origin=\(journey[0].ap[0])&")
//            }else if journey.count > 2{
                for i in 0..<journey.count{
                    origin.append("origin[\(i)]=\(journey[i].ap[0])&")
                }
//            }else{
//                origin.append("origin=\(journey[0].ap[0])&")
//            }
        }
        
        return origin
    }
    
    func getDestination(journey:[Journey])->String{
        var destination = ""
        if tripType == "single" || tripType == "return"{
            destination.append("destination=\(journey[0].ap[1])&")
        }else{
//            if journey.count == 1{
//                destination.append("destination=\(journey[0].ap[1])&")
//            }else if journey.count > 2{
                for i in 0..<journey.count{
                    destination.append("destination[\(i)]=\(journey[i].ap[1])&")
                }
//            }else{
//                destination.append("destination=\(journey[0].ap[1])&")
//            }
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
            
            print("appliedFilters=",appliedFilters)
            
            //     Times
            if (appliedFilters.contains(.Times))
            {
                //     Departure Time
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
                
                
                //     Arrival Time
                var arrivalTime = ""
                if let arrivalDateEarliest = userSelectedFilters?.arDt.earliest{
                    let earliest = arrivalDateEarliest.components(separatedBy: " ")
                    var earliestTimeInverval = TimeInterval()
                    if earliest.count > 1{
                        earliestTimeInverval = convertFrom(string: earliest[1])!
                    }else{
                        earliestTimeInverval = convertFrom(string: earliest[0])!
                    }
                    let intTime = Int(earliestTimeInverval/60)
                    arrivalTime.append("filters[\(i)][ar_dt][0]=\(intTime)&")
                }
                
                if let arrivalDateLatest = userSelectedFilters?.arDt.latest{
                    let latest = arrivalDateLatest.components(separatedBy: " ")
                    let latestTimeInverval = convertFrom(string: latest[1])
                    let intTime = Int(latestTimeInverval!/60)
                    arrivalTime.append("filters[\(i)][ar_dt][1]=\(intTime)&")
                }
                
                filterString.append("\(depTime)&\(arrivalTime)")
            }
            
            
            //     Duration
            if (appliedFilters.contains(.Duration))
            {
                //     Trip Duration
                var tripDuration = ""
                if let tripMinTime = Int(userSelectedFilters!.tt.minTime!){
                    let minTime = tripMinTime/60
                    tripDuration.append("filters[\(i)][tt][0]=\(minTime)&")
                }
                if let tripMaxTime = Int(userSelectedFilters!.tt.maxTime!){
                    let maxTime = tripMaxTime/60
                    tripDuration.append("filters[\(i)][tt][1]=\(maxTime)")
                }
                
                
                
                //     Layover Duration
                var layoverDuration = ""
                if let layoverMinTime = Int(userSelectedFilters!.lott!.minTime!){
                    let minTime = layoverMinTime/60
                    layoverDuration.append("filters[\(i)][lott][0]=\(minTime)&")
                }
                
                if let layoverMaxTime = Int(userSelectedFilters!.lott!.maxTime!){
                    let maxTime = layoverMaxTime/60
                    layoverDuration.append("filters[\(i)][lott][1]=\(maxTime)&")
                }
                
                filterString.append("\(tripDuration)&\(layoverDuration)")
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
        
        
        return filterString
    }
    
    func getAppliedFiltersForSharingIntJourney(legs:[IntFlightResultDisplayGroup])->String
    {
        var filterString = ""
        
        if legs.count > 0{
            let userSelectedFilters = legs[0].userSelectedFilters
            let appliedFilters = legs[0].appliedFilters

            for i in 0..<userSelectedFilters.count{
                filterString.append("&")
                
                //     Times
                if (appliedFilters.contains(.Times))
                {
                    //     Departure Time
                    var depTime = ""
                    let earliest = userSelectedFilters[i].dt.earliest
                    let earliestTimeInverval = convertFrom(string: earliest)
                    let intEarliestTime = Int(earliestTimeInverval!/60)
                    depTime.append("filters[\(i)][dep_dt][0]=\(intEarliestTime)&")
                    
                    
                    let latest = userSelectedFilters[i].dt.latest
                    let latestTimeInverval = convertFrom(string: latest)
                    let intLatestTime = Int(latestTimeInverval!/60)
                    depTime.append("filters[\(i)][dep_dt][1]=\(intLatestTime)")
                    
                    
                    
                    //     Arrival Time
                    var arrivalTime = ""
                    let arrivalDateEarliest = userSelectedFilters[i].arDt.earliest
                        let earliestArrival = arrivalDateEarliest.components(separatedBy: " ")
                        let earliestArrivalTimeInverval = convertFrom(string: earliestArrival[1])
                        let intArrivalTime = Int(earliestArrivalTimeInverval!/60)
                        arrivalTime.append("filters[\(i)][ar_dt][0]=\(intArrivalTime)&")
                    
                    
                    let arrivalDateLatest = userSelectedFilters[i].arDt.latest
                        let latestArrival = arrivalDateLatest.components(separatedBy: " ")
                        let latestArrivalTimeInverval = convertFrom(string: latestArrival[1])
                        let intLatestArrivalTime = Int(latestArrivalTimeInverval!/60)
                        arrivalTime.append("filters[\(i)][ar_dt][1]=\(intLatestArrivalTime)&")
                    
                    
                    filterString.append("\(depTime)&\(arrivalTime)")
                }
                
                
                //     Duration
                if (appliedFilters.contains(.Duration))
                {
                    //     Trip Duration
                    var tripDuration = ""
                    if let tripMinTime = Int(userSelectedFilters[i].tt.minTime!){
                        let minTime = tripMinTime/60
                        tripDuration.append("filters[\(i)][tt][0]=\(minTime)&")
                    }
                    if let tripMaxTime = Int(userSelectedFilters[i].tt.maxTime!){
                        let maxTime = tripMaxTime/60
                        tripDuration.append("filters[\(i)][tt][1]=\(maxTime)")
                    }
                    
                    
                    
                    //     Layover Duration
                    var layoverDuration = ""
                    if let layoverMinTime = Int(userSelectedFilters[i].lott.minTime!){
                        let minTime = layoverMinTime/60
                        layoverDuration.append("filters[\(i)][lott][0]=\(minTime)&")
                    }
                    
                    if let layoverMaxTime = Int(userSelectedFilters[i].lott.maxTime!){
                        let maxTime = layoverMaxTime/60
                        layoverDuration.append("filters[\(i)][lott][1]=\(maxTime)&")
                    }
                    
                    filterString.append("\(tripDuration)&\(layoverDuration)")
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

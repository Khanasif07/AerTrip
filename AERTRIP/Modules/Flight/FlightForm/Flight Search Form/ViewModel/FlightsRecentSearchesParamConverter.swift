//
//  FlightsRecentSearchesParamConverter.swift
//  AERTRIP
//
//  Created by Rishabh on 24/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class FlightsRecentSearchesParamConverter: NSObject {
    
    @objc func convertParam(_ params: NSArray) -> NSDictionary {
        var filtersDict = JSONDictionary()
        params.enumerated().forEach { (filterParam) in
            let legIndex = filterParam.offset
            let filterJson = JSON(filterParam.element)
            let legFilterParams = convertToDict(filterIndex: legIndex, filterJSON: filterJson)
            filtersDict = filtersDict.merging(legFilterParams) { $1 }
        }
        let dictToReturn = NSDictionary(dictionary: filtersDict)
        return dictToReturn
    }
    
    private func convertToDict(filterIndex: Int, filterJSON: JSON) -> JSONDictionary {
        var jsonDict = JSONDictionary()
        let filter = filterJSON

        if let stops = filter["stp"].array {
            stops.enumerated().forEach { (index, stop) in
                jsonDict["filters[\(filterIndex)][stp][\(index)]"] = stop.stringValue
            }
        }
        
        if let depDt = filter["dep_dt"].array {
            jsonDict["filters[\(filterIndex)][dep_dt][0]"] = depDt[0].stringValue
            jsonDict["filters[\(filterIndex)][dep_dt][1]"] = depDt[1].stringValue
        }
        
        if let arDt = filter["ar_dt"].array {
            if let leftVal = arDt[0].int {
                jsonDict["filters[\(filterIndex)][ar_dt][0]"] = leftVal.toString
            }
            if let rightVal = arDt[1].int {
                jsonDict["filters[\(filterIndex)][ar_dt][1]"] = rightVal.toString
            }
        }
        
        if let airlines = filter["al"].array {
            airlines.enumerated().forEach { (index, airline) in
                jsonDict["filters[\(filterIndex)][al][\(index)]"] = airline.stringValue
            }
        }
        
        if let minTime = filter["duration"]["min"].int {
            jsonDict["filters[\(filterIndex)][tt][0]"] = ((minTime)/3600).toString
        }
        
        if let maxTime = filter["duration"]["max"].int {
            jsonDict["filters[\(filterIndex)][tt][1]"] = ((maxTime)/3600).toString
        }
        
        if let minTime = filter["layoverDuration"]["min"].int {
            jsonDict["filters[\(filterIndex)][lott][0]"] = ((minTime)/3600).toString
        }
        
        if let maxTime = filter["layoverDuration"]["max"].int {
            jsonDict["filters[\(filterIndex)][lott][1]"] = ((maxTime)/3600).toString
        }
        
        if let price = filter["pr"].array {
            jsonDict["filters[\(filterIndex)][pr][0]"] = price[0].stringValue
            jsonDict["filters[\(filterIndex)][pr][1]"] = price[1].stringValue
        }
        
        if let loap = filter["loap"].array {
            loap.enumerated().forEach { (index, airline) in
                jsonDict["filters[\(filterIndex)][loap][\(index)]"] = airline.stringValue
            }
        }
        
        return jsonDict
    }
    
    func getAppliedFiltersForSharingDomesticJourney(legs:[FlightResultDisplayGroup], isConditionReverced:Bool) -> String
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
//            if dynamicFilters.aircraft.selectedAircraftsArray.count > 0{
//                var aircraft = ""
//                for n in 0..<dynamicFilters.aircraft.selectedAircraftsArray.count{
//                    aircraft.append("filters[\(i)][aircraft][\(n)]=\(dynamicFilters.aircraft.selectedAircraftsArray[n].name)&")
//                }
//
//                filterString.append(aircraft)
//            }
            
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
                if let pr = userSelectedFilters?.pr{
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

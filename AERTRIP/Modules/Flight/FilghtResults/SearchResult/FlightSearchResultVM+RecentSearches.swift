//
//  FlightSearchResultVM+RecentSearches.swift
//  AERTRIP
//
//  Created by Rishabh on 29/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension FlightSearchResultVM {
    
    func updateDomesticRecentSearches() {
        print("~~~~~~~~~~~~~~~~~~~ FLIGHTS RECENT FILTERS ~~~~~~~~~~~~~~~~~~~")
        let filtersDict = getAppliedFiltersForSharingDomesticJourney(legs: flightLegs, isConditionReversed: false)
        var recentSearchParamsWithFilters = recentSearchParameters
        if let dataQueryStr = recentSearchParameters["data[query]"] as? String {
            if var dataQuery = convertStringToDictionary(text: dataQueryStr) {
                dataQuery["filters"] = filtersDict//.map { convertDictionaryToString(dict: $0).removeAllWhiteSpacesAndNewLines }
                recentSearchParamsWithFilters["data[query]"] = convertDictionaryToString(dict: dataQuery)
            }
        }
            
      
        APICaller.shared.updateFlightsRecentSearch(params: recentSearchParamsWithFilters) { (dict, err) in
            
        }
    }
    
    func getAppliedFiltersForSharingDomesticJourney(legs:[FlightResultDisplayGroup], isConditionReversed:Bool) -> [JSONDictionary]
    {
        var filterArr = [JSONDictionary]()
        
        for i in 0..<legs.count{
            var filterDict = JSONDictionary()
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
                        
            filterDict["fq"] = fqArray
                        
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
//                filterString.append("sort[]=humane-sorting_asc&")
            }
            
            if legs[i].sortOrder == .Price{
                if isConditionReversed{
//                    filterString.append("sort[]=price-sorting_desc&")
                }else{
//                    filterString.append("sort[]=price-sorting_asc&")
                }
            }
            
            if legs[i].sortOrder == .Duration{
                if isConditionReversed{
//                    filterString.append("sort[]=duration-sorting_desc&")
                }else{
//                    filterString.append("sort[]=duration-sorting_asc&")
                }
            }
            
            if legs[i].sortOrder == .Depart{
                if isConditionReversed{
//                    filterString.append("sort[]=depart-sorting_desc&")
                }else{
//                    filterString.append("sort[]=depart-sorting_asc&")
                }
            }
            
            if legs[i].sortOrder == .Arrival{
                if isConditionReversed{
//                    filterString.append("sort[]=arrive-sorting_desc&")
                }else{
//                    filterString.append("sort[]=arrive-sorting_asc&")
                }
            }
            
            
            //     Times
            if (appliedFilters.contains(.Times))
            {
                
                //     Departure Time
                if appliedSubFilters.contains(.departureTime){
                    var depTimeArr = [Int]()
                    if let earliest = userSelectedFilters?.dt.earliest{
                        if let earliestTimeInverval = convertFrom(string: earliest){
                            let intTime = Int(earliestTimeInverval/60)
                            depTimeArr.append(intTime)
                        }
                    }
                    
                    if let latest = userSelectedFilters?.dt.latest{
                        if let latestTimeInverval = convertFrom(string: latest){
                            let intTime = Int(latestTimeInverval/60)
                            depTimeArr.append(intTime)
                        }
                    }
                    filterDict["dep_dt"] = depTimeArr
                }
                
                
                //     Arrival Time
                if appliedSubFilters.contains(.arrivalTime){
                    var arDt = [Int]()
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
                        arDt.append(intTime)
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
                                arDt.append(intTime)
                            }
                        }else{
                            if let latestTimeInverval = convertFrom(string: latest[1]){
                                let intTime = Int(latestTimeInverval/60)
                                arDt.append(intTime)
                            }
                        }
                    }
                    
                    filterDict["ar_dt"] = arDt
                }
            }
            
            
            //     Duration
            if (appliedFilters.contains(.Duration))
            {
                //     Trip Duration
                
                if appliedSubFilters.contains(.tripDuration){
                    var tripDuration = [Int]()
                    if let tripMinTime = Int(userSelectedFilters?.tt.minTime ?? "0"){
                        let minTime = tripMinTime/3600
                        tripDuration.append(minTime)
                    }
                    if let tripMaxTime = Int(userSelectedFilters?.tt.maxTime ?? "0"){
                        let maxTime = tripMaxTime/3600
                        tripDuration.append(maxTime)
                    }
                    filterDict["tt"] = tripDuration
                }
                
                //     Layover Duration
                if appliedSubFilters.contains(.layoverDuration){
                    var layoverDuration = [Int]()
                    if let layoverMinTime = Int(userSelectedFilters?.lott?.minTime ?? "0"){
                        let minTime = layoverMinTime/3600
                        layoverDuration.append(minTime)
                    }
                    
                    if let layoverMaxTime = Int(userSelectedFilters?.lott?.maxTime ?? "0"){
                        let maxTime = layoverMaxTime/3600
                        layoverDuration.append(maxTime)
                    }
                    
                    filterDict["lott"] = layoverDuration
                }
            }
            
            
            //     Airline
            if (appliedFilters.contains(.Airlines))
            {
                if let airlines = userSelectedFilters?.al{
                    filterDict["al"] = airlines
                }
            }
            
            
            //     Airport
            if (appliedFilters.contains(.Airport))
            {
                if uiFilters.contains(.layoverAirports){
                    if let loap = userSelectedFilters?.loap{
                        filterDict["loap"] = loap
                    }
                }
//                else{
                    
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
                    filterDict["ap"] = airportsArray
//                }
            }
            
            //     Quality
            if (appliedFilters.contains(.Quality))
            {
                var quality = [String]()
                if let fq = userSelectedFilters?.fq{
                    let fqArray = Array(fq.keys)
                    quality = fqArray
                }
                filterDict["fq"] = quality
            }
            
            
            //     Price
            if (appliedFilters.contains(.Price))
            {
                if let pr = userSelectedFilters?.pr{
                    let price = [pr.minPrice, pr.maxPrice]
                    filterDict["pr"] = price
                }
                
                if uiFilters.contains(.refundableFares){
                    filterDict["fares[]"] = 1
                }
            }
            
            //     Stops
            if (appliedFilters.contains(.stops))
            {
                if let stp = userSelectedFilters?.stp{
                    filterDict["stp"] = stp
                }
            }
            filterArr.append(filterDict)
        }
        return filterArr
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
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    func convertDictionaryToString(dict: JSONDictionary) -> String {
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonStr = String(data: data, encoding: .utf8) ?? ""
        return jsonStr
    }
}

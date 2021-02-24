//
//  FlightSearchResultVM+RecentSearches.swift
//  AERTRIP
//
//  Created by Rishabh on 29/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//


// MARK: Used to update filters in recent searches
import Foundation

extension FlightSearchResultVM {
    
    func updateDomesticRecentSearches() {
        let filtersDict = getAppliedFiltersForSharingDomesticJourney(legs: flightLegs)
        var recentSearchParamsWithFilters = recentSearchParameters
        if let dataQueryStr = recentSearchParameters["data[query]"] as? String {
            if var dataQuery = convertStringToDictionary(text: dataQueryStr) {
                dataQuery = dataQuery.filter { !$0.key.contains("filters") }
                dataQuery["filters"] = filtersDict
                //Golu Update causing adult count 0
                dataQuery["adult"] = Int(String(describing: dataQuery["adult"] ?? "0")) ?? 0
                dataQuery["child"] = Int(String(describing: dataQuery["child"] ?? "0")) ?? 0
                dataQuery["infant"] = Int(String(describing: dataQuery["infant"] ?? "0")) ?? 0
                recentSearchParamsWithFilters["data[query]"] = convertDictionaryToString(dict: dataQuery)
            }
        }
            
        APICaller.shared.updateFlightsRecentSearch(params: recentSearchParamsWithFilters) { (dict, err) in
            
        }
    }
    
    func updateInternationalRecentSearches() {
        let filtersDict = getAppliedFiltersForSharingInternationalJourney(legs: intFlightLegs)
        var recentSearchParamsWithFilters = recentSearchParameters
        if let dataQueryStr = recentSearchParameters["data[query]"] as? String {
            if var dataQuery = convertStringToDictionary(text: dataQueryStr) {
                dataQuery = dataQuery.filter { !$0.key.contains("filters") }
                dataQuery["filters"] = filtersDict
                //Golu Update causing adult count 0
                dataQuery["adult"] = Int(String(describing: dataQuery["adult"] ?? "0")) ?? 0
                dataQuery["child"] = Int(String(describing: dataQuery["child"] ?? "0")) ?? 0
                dataQuery["infant"] = Int(String(describing: dataQuery["infant"] ?? "0")) ?? 0
                recentSearchParamsWithFilters["data[query]"] = convertDictionaryToString(dict: dataQuery)
            }
        }
            
        APICaller.shared.updateFlightsRecentSearch(params: recentSearchParamsWithFilters) { (dict, err) in
            
        }
    }
    
    func getAppliedFiltersForSharingDomesticJourney(legs:[FlightResultDisplayGroup]) -> [JSONDictionary] {
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
             
            if !fqArray.isEmpty {
                filterDict["fq"] = fqArray
            }
                        
            //Aircraft
            if !dynamicFilters.aircraft.selectedAircraftsArray.isEmpty {
                filterDict["eq"] = dynamicFilters.aircraft.selectedAircraftsArray.map { $0.code }
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
                    let toAirports = to.flatMap { $0.value }
                    airportsArray.append(contentsOf: toAirports)
                }
                
                if let fr = userSelectedFilters?.cityapN.fr{
                    let frAirports = fr.flatMap { $0.value }
                    airportsArray.append(contentsOf: frAirports)
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
                if let pr = userSelectedFilters?.pr, legs[i].initiatedFilters.contains(.price) {
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
            
            if legs[i].UIFilters.contains(.hideMultiAirlineItinarery) {
                filterDict["hideMultiAl"] = 1
            }
            
            filterArr.append(filterDict)
        }
        return filterArr
    }
    
    func getAppliedFiltersForSharingInternationalJourney(legs:[IntFlightResultDisplayGroup]) -> [JSONDictionary] {
        
        var filterArr = [JSONDictionary]()
        
        if legs.count > 0{
            
            let userSelectedFilters = legs[0].userSelectedFilters
            let appliedFilters = legs[0].appliedFilters
            let appliedSubFilters = legs[0].appliedSubFilters
            let uiFilters = legs[0].UIFilters
            let dynamicFilters = legs[0].dynamicFilters
            let numberOfLegs = legs[0].numberOfLegs
                        
            for i in 0..<userSelectedFilters.count
            {
                var filterDict = JSONDictionary()
                
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
                
                if !fqArray.isEmpty {
                    filterDict["fq"] = fqArray
                }
                
                //Aircraft
                if !dynamicFilters.aircraft.selectedAircraftsArray.isEmpty {
                    filterDict["eq"] = dynamicFilters.aircraft.selectedAircraftsArray.map { $0.code }
                }
                
                //     Times
                if (appliedFilters.contains(.Times))
                {
                    //     Departure Time
                    if ((appliedSubFilters[i]?.contains(.departureTime)) ?? false){
                        var depTimeArr = [Int]()
                        let earliest = userSelectedFilters[i].dt.earliest
                        if let earliestTimeInverval = convertFrom(string: earliest){
                            let intEarliestTime = Int(earliestTimeInverval/60)
                            depTimeArr.append(intEarliestTime)
                        }
                        
                        let latest = userSelectedFilters[i].dt.latest
                        if let latestTimeInverval = convertFrom(string: latest){
                            let intLatestTime = Int(latestTimeInverval/60)
                            depTimeArr.append(intLatestTime)
                        }
                        
                        filterDict["dep_dt"] = depTimeArr
                    }
                    
                    
                    //     Arrival Time
                    
                    if ((appliedSubFilters[i]?.contains(.arrivalTime)) ?? false)
                    {
                        var arDt = [Int]()
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
                            arDt.append(intArrivalTime)
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
                                arDt.append(intTime)
                            }
                        }else{
                            if let latestTimeInverval = convertFrom(string: latestArrival[1]){
                                let intTime = Int(latestTimeInverval/60)
                                arDt.append(intTime)
                            }
                        }
                        
                        filterDict["ar_dt"] = arDt
                    }
                }
                
                
                //     Duration
                if (appliedFilters.contains(.Duration))
                {
                    //     Trip Duration
                    if ((appliedSubFilters[i]?.contains(.tripDuration)) ?? false)
                    {
                        var tripDuration = [Int]()
                        if bookFlightObject.flightSearchType.rawValue == 1 {
                            let departTime = userSelectedFilters[0].tt
                            let returnTime = userSelectedFilters[1].tt
                            let minTime = Int(departTime.minTime ?? "0") ?? 0 < Int(returnTime.minTime ?? "0") ?? 0 ? Int(departTime.minTime ?? "0") ?? 0 : Int(returnTime.minTime ?? "0") ?? 0
                            let maxTime = Int(departTime.maxTime ?? "0") ?? 0 > Int(returnTime.maxTime ?? "0") ?? 0 ? Int(departTime.maxTime ?? "0") ?? 0 : Int(returnTime.maxTime ?? "0") ?? 0
                            tripDuration = [minTime/3600, maxTime/3600]
                        } else {
                            if let tripMinTime = Int(userSelectedFilters[i].tt.minTime ?? "0"){
                                let minTime = tripMinTime/3600
                                tripDuration.append(minTime)
                            }
                            if let tripMaxTime = Int(userSelectedFilters[i].tt.maxTime ?? "0"){
                                let maxTime = tripMaxTime/3600
                                tripDuration.append(maxTime)
                            }
                        }
                        filterDict["tt"] = tripDuration
                    }
                    
                    //     Layover Duration
                    if ((appliedSubFilters[i]?.contains(.layoverDuration)) ?? false)
                    {
                        var layoverDuration = [Int]()
                        if bookFlightObject.flightSearchType.rawValue == 1 {
                            let departTime = userSelectedFilters[0].lott
                            let returnTime = userSelectedFilters[1].lott
                            let minTime = Int(departTime.minTime ?? "0") ?? 0 < Int(returnTime.minTime ?? "0") ?? 0 ? Int(departTime.minTime ?? "0") ?? 0 : Int(returnTime.minTime ?? "0") ?? 0
                            let maxTime = Int(departTime.maxTime ?? "0") ?? 0 > Int(returnTime.maxTime ?? "0") ?? 0 ? Int(departTime.maxTime ?? "0") ?? 0 : Int(returnTime.maxTime ?? "0") ?? 0
                            layoverDuration = [minTime/3600, maxTime/3600]
                        } else {
                            if let layoverMinTime = Int(userSelectedFilters[i].lott.minTime ?? "0"){
                                let minTime = layoverMinTime/3600
                                layoverDuration.append(minTime)
                            }
                            
                            if let layoverMaxTime = Int(userSelectedFilters[i].lott.maxTime ?? "0"){
                                let maxTime = layoverMaxTime/3600
                                layoverDuration.append(maxTime)
                            }
                        }
                        filterDict["lott"] = layoverDuration
                    }
                }
                
                
                //     Airline
                if (appliedFilters.contains(.Airlines))
                {
                    filterDict["al"] = userSelectedFilters[0].al
                }
                
                
                //     Airport
                if (uiFilters.contains(.layoverAirports))
                {
                    filterDict["loap"] = userSelectedFilters[i].loap
                }
                
                //     Airport - originDestinationSelectedForReturnJourney
                
                if uiFilters.contains(.originDestinationSelectedForReturnJourney) {
                    let selectedAp = Array(Set(userSelectedFilters[0].cityapn.returnOriginAirports + userSelectedFilters[0].cityapn.returnDestinationAirports))
                    
                    filterDict["ap"] = selectedAp
                    
                } else if ((appliedSubFilters[i]?.contains(.originAirports) ?? false) || (appliedSubFilters[i]?.contains(.destAirports)) ?? false) {
                    
                    var airportsArray = [String]()
                    
                    let fr = userSelectedFilters[i].cityapn.fr
                    let to = userSelectedFilters[i].cityapn.to
                    
                    airportsArray.append(contentsOf: fr.flatMap { $0.value } )
                    airportsArray.append(contentsOf: to.flatMap { $0.value } )
                    airportsArray = Array(Set(airportsArray))
                    
                    filterDict["ap"] = airportsArray
                }
                
//                if uiFilters.contains(.originDestinationSelectedForReturnJourney)
//                {
//                    var airportsArray = [String]()
//
//                    let returnOriginAirports = userSelectedFilters[0].cityapn.returnOriginAirports
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
//                    filterDict["ap"] = airportsArray
//                }
                
                
                
                //     Quality
                if (appliedFilters.contains(.Quality))
                {
                    let fqArray = Array(userSelectedFilters[i].fq.keys)
                    filterDict["fq"] = fqArray
                }
                
                
                //     Stops
                if (appliedFilters.contains(.stops))
                {
                    filterDict["stp"] = userSelectedFilters[i].stp
                }
                
                //     Price
                if appliedFilters.contains(.Price)
                {
                    if legs[0].initiatedFilters[i]?.contains(.price) ?? false {
                        
                    filterDict["pr"] = [userSelectedFilters[i].pr.minPrice, userSelectedFilters[i].pr.maxPrice]
                        
                    }
                    
                    if legs[0].initiatedFilters[0]?.contains(.price) ?? false {
                        
                        if bookFlightObject.flightSearchType.rawValue == 1 {
                            filterDict["pr"] = [userSelectedFilters[0].pr.minPrice, userSelectedFilters[0].pr.maxPrice]
                        }
                        
                    }
                    
                    if uiFilters.contains(.refundableFares){
                        filterDict["fares[]"] = 1
                    }
                }
                if legs[0].UIFilters.contains(.hideMultiAirlineItinarery) {
                    filterDict["hideMultiAl"] = 1
                }
                filterArr.append(filterDict)
            }
        }
        if legs[0].UIFilters.contains(.originDestinationSame) {
            filterArr[0]["departReturnSame"] = 1
        }
        return filterArr
    }
    
    func convertFrom(string : String) ->  TimeInterval? {
        
        if string == "24.00" || string == "24:00" {
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

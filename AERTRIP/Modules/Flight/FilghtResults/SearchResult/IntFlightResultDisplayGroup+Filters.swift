//
//  IntFlightResultDisplayGroup+Filters.swift
//  Aertrip
//
//  Created by Rishabh on 20/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

extension IntFlightResultDisplayGroup  {
    
    func allAirlinesSelected() {
        userSelectedFilters[0].al = []
        userSelectedFilters[0].multiAl = 0
        appliedFilters.remove(.Airlines)
        UIFilters.remove(.hideMultiAirlineItinarery)
        applyFilters(index: 0)
    }
    
    func hideMultiAirlineItineraryUpdated(_ filter: AirlineLegFilter ) {
        if filter.hideMultipleAirline {
            userSelectedFilters[0].multiAl = 0
            UIFilters.insert(.hideMultiAirlineItinarery)
        }else {
            userSelectedFilters[0].multiAl = 1
            UIFilters.remove(.hideMultiAirlineItinarery)
        }
        applyFilters(index: 0)
    }
    
    
    func airlineFilterUpdated(_ filter: AirlineLegFilter) {
        
        let selectedAirlines = filter.airlinesArray.filter{ $0.isSelected }
        let airlineCodesArray = selectedAirlines.map{ $0.code }
        
        userSelectedFilters[0].al = airlineCodesArray
        
        if userSelectedFilters[0].al.count > 0 {
            appliedFilters.insert(.Airlines)
        } else {
            //remove working fine
            appliedFilters.remove(.Airlines)
        }
        applyFilters(index: 0)
        
    }
    
    
    func applyMultiItinaryAirlineFilter(index : Int,  _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        let hideMultiAirlineItinerary =  userSelectedFilters[index].multiAl == 1 ? false : true
        
        if hideMultiAirlineItinerary {
            
            let outputArray = inputArray.filter{
                
                if (Set($0.legsWithDetail[0].al).count < 2) && (Set($0.legsWithDetail[1].al).count < 2) {
                    return true
                }
                return false
            }
            
            return outputArray
        }
        
        return  inputArray
    }
    
    func applyAirlineFilter(index : Int, _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        let filteredAirlineSet = Set(userSelectedFilters[0].al)
        
        if filteredAirlineSet.count == 0 { return outputArray }
        
        outputArray = inputArray.filter{
            let journeySet = Set($0.al)
            
            if journeySet.isDisjoint(with:filteredAirlineSet) {
                return false
            }
            return true
        }
        
        return outputArray
    }
    
    
    //MARK:- Sorting
    
    func sortFilterChanged(sort: Sort) {
        
        if sort == .Smart {
            appliedFilters.remove(.sort)
        }else {
            appliedFilters.insert(.sort)
        }
        //
        self.sortOrder = sort
        
        //        self.applySort(inputArray: filteredJourneyArray)
    }
    
    func departSortFilterChanged(departMode: Bool) {
        
        //        appliedFilters.insert(.sort)
        //        if departMode {
        //            self.sortOrder = .DurationLatestFirst
        //        }else {
        //            self.sortOrder = .Depart
        //        }
        //
        //        self.applySort(inputArray: filteredJourneyArray)
    }
    
    func arrivalSortFilterChanged(arrivalMode: Bool) {
        
        //        appliedFilters.insert(.sort)
        //        if arrivalMode {
        //            self.sortOrder = .ArrivalLatestFirst
        //        }
        //        else {
        //                self.sortOrder = .Arrival
        //        }
        //
        //        self.applySort(inputArray: filteredJourneyArray)
    }
    
    
    func applySort2( inputArray : [IntMultiCityAndReturnWSResponse.Results.J] ) {
        
        var sortArray = inputArray
        switch  sortOrder {
        case .Price:
            sortArray.sort(by: {$0.price < $1.price})
        case .Duration:
            sortArray.sort(by: {$0.duration < $1.duration })
        case .Smart :
            sortArray.sort(by: {$0.computedHumanScore! < $1.computedHumanScore! })
        case .Depart:
            sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
        case .Arrival:
            sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })
        case .DurationLatestFirst :
            sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
        case .ArrivalLatestFirst :
            sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })
        }
        
        self.filteredJourneyArray = sortArray
        
    }
    
    //MARK:- Stops Filter
    
    func stopsSelectionChangedAt(index : Int, stops: [Int]) {
        let stopsStringsArray = stops.map{ String($0) }
        userSelectedFilters[index].stp = stopsStringsArray
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            return obj.stp.count != inputFilter[legIndex].stp.count && !obj.stp.isEmpty
        }){
            appliedFilters.insert(.stops)
        }else{
            appliedFilters.remove(.stops)
        }
        
        applyFilters(index: index)
    }
    
    func allStopsSelected() {
        userSelectedFilters.enumerated().forEach { (legIndex,obj) in
            userSelectedFilters[legIndex].stp = inputFilter[legIndex].stp
        }
        appliedFilters.remove(.stops)
        applyFilters(index: 0)
        
    }
    
    func applyStopsFilter(index : Int, _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J] ) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        var outputArray = inputArray
        
        userSelectedFilters.enumerated().forEach { (legIndex, obj) in
            let stopSet = Set(obj.stp)
            outputArray = outputArray.filter { (journey) -> Bool in
                if stopSet.isEmpty{
                    return true
                }else{
                    return stopSet.contains(journey.legsWithDetail[legIndex].stp)
                }
            }
        }
        
        return outputArray
    }
    
    
    //MARK:- Duration Filter
    
    func tripDurationChanged(index: Int, min: CGFloat, max: CGFloat) {
        
        var durationChanged = false
        var layOverChanged = false
        
        print(min)
        //        print(max)
        
        var Number = NSNumber(floatLiteral: Double(min * 3600))
        userSelectedFilters[index].tt.minTime = Number.stringValue
        Number = NSNumber(floatLiteral: Double(max * 3600))
        userSelectedFilters[index].tt.maxTime = Number.stringValue
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            
            let inputMinDurationValue = Double(inputFilter[legIndex].tt.minTime ?? "") ?? 0
            let inputMaxDurationValue = Double(inputFilter[legIndex].tt.maxTime ?? "") ?? 0
            
            let convertedInputMinDurationValue = (floor((inputMinDurationValue) / 3600)) * 3600
            let convertedInputMaxDurationValue = (ceil(inputMaxDurationValue / 3600)) * 3600
            
            let userSelectedMinDurationValue = Double(obj.tt.minTime ?? "") ?? 0
            let userSelectedMaxDurationValue = Double(obj.tt.maxTime ?? "") ?? 0
            
            let convertedSelectedMinDurationValue = (floor((userSelectedMinDurationValue) / 3600)) * 3600
            let convertedSelectedMaxDurationValue = (ceil(userSelectedMaxDurationValue / 3600)) * 3600
            
//            print(legIndex)
//            print(convertedSelectedMinDurationValue)
//            print(convertedSelectedMaxDurationValue)
//            print(convertedInputMinDurationValue)
//            print(convertedInputMaxDurationValue)
            
            return convertedSelectedMinDurationValue != convertedInputMinDurationValue || convertedSelectedMaxDurationValue != convertedInputMaxDurationValue
        }){
            durationChanged = true
        }else{
            durationChanged = false
        }
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            
            
            let inputMinLayoverValue = Double(inputFilter[legIndex].lott.minTime ?? "") ?? 0
            let inputMaxLayoverValue = Double(inputFilter[legIndex].lott.maxTime ?? "") ?? 0
            
            let convertedInputMinLayoverValue = (floor((inputMinLayoverValue) / 3600)) * 3600
            let convertedInputMaxLayoverValue = (ceil(inputMaxLayoverValue / 3600)) * 3600
            
            let userSelectedMinLayoverValue = Double(obj.lott.minTime ?? "") ?? 0
            let userSelectedMaxLayoverValue = Double(obj.lott.maxTime ?? "") ?? 0
            
            let convertedSelectedMinLayoverValue = (floor((userSelectedMinLayoverValue) / 3600)) * 3600
            let convertedSelectedMaxLayoverValue = (ceil(userSelectedMaxLayoverValue / 3600)) * 3600
            
            return convertedSelectedMinLayoverValue != convertedInputMinLayoverValue || convertedSelectedMaxLayoverValue != convertedInputMaxLayoverValue
            
        }){
            layOverChanged = true
        }else{
            layOverChanged = false
        }
        
        if layOverChanged || durationChanged {
            appliedFilters.insert(.Duration)
        }else{
            appliedFilters.remove(.Duration)
            
        }
//        print(appliedFilters)
        applyFilters(index: index)
    }
    
    func layoverDurationChanged(index : Int, min: CGFloat, max: CGFloat) {
        
        var durationChanged = false
        var layOverChanged = false
        
        var Number = NSNumber(floatLiteral: Double(min * 3600))
        userSelectedFilters[index].lott.minTime = Number.stringValue
        
        Number = NSNumber(floatLiteral: Double(max * 3600))
        userSelectedFilters[index].lott.maxTime = Number.stringValue
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            
            let inputMinLayoverValue = Double(inputFilter[legIndex].lott.minTime ?? "") ?? 0
            let inputMaxLayoverValue = Double(inputFilter[legIndex].lott.maxTime ?? "") ?? 0
            
            let convertedInputMinLayoverValue = (floor((inputMinLayoverValue) / 3600)) * 3600
            let convertedInputMaxLayoverValue = (ceil(inputMaxLayoverValue / 3600)) * 3600
            
            let userSelectedMinLayoverValue = Double(obj.lott.minTime ?? "") ?? 0
            let userSelectedMaxLayoverValue = Double(obj.lott.maxTime ?? "") ?? 0
            
            let convertedSelectedMinLayoverValue = (floor((userSelectedMinLayoverValue) / 3600)) * 3600
            let convertedSelectedMaxLayoverValue = (ceil(userSelectedMaxLayoverValue / 3600)) * 3600
            
            return convertedSelectedMinLayoverValue != convertedInputMinLayoverValue || convertedSelectedMaxLayoverValue != convertedInputMaxLayoverValue
            
        }){
            layOverChanged = true
        } else {
            //working fine
            layOverChanged = false
        }
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            
            let inputMinDurationValue = Double(inputFilter[legIndex].tt.minTime ?? "") ?? 0
            let inputMaxDurationValue = Double(inputFilter[legIndex].tt.maxTime ?? "") ?? 0
            
            let convertedInputMinDurationValue = (floor((inputMinDurationValue) / 3600)) * 3600
            let convertedInputMaxDurationValue = (ceil(inputMaxDurationValue / 3600)) * 3600
            
            let userSelectedMinDurationValue = Double(obj.tt.minTime ?? "") ?? 0
            let userSelectedMaxDurationValue = Double(obj.tt.maxTime ?? "") ?? 0
            
            let convertedSelectedMinDurationValue = (floor((userSelectedMinDurationValue) / 3600)) * 3600
            let convertedSelectedMaxDurationValue = (ceil(userSelectedMaxDurationValue / 3600)) * 3600
            
            return convertedSelectedMinDurationValue != convertedInputMinDurationValue || convertedSelectedMaxDurationValue != convertedInputMaxDurationValue
            
        }){
            durationChanged = true
        }else{
            durationChanged = false
        }
        
        if layOverChanged || durationChanged {
            appliedFilters.insert(.Duration)
        } else {
            appliedFilters.remove(.Duration)
        }
        
//        print(appliedFilters)
        applyFilters(index: index)
    }
    
    func applyDurationFilter(index : Int, _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J] ) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        userSelectedFilters.enumerated().forEach { (legIndex, obj) in
            
            let minTripDuration = Int(obj.tt.minTime ?? "") ?? 0
            let maxTripDuration = Int(obj.tt.maxTime ?? "") ?? 0
            
            outputArray = outputArray.filter { (journey) -> Bool in
                
                let journeyDuration = journey.legsWithDetail[legIndex].duration
                return journeyDuration >= minTripDuration && journeyDuration <= maxTripDuration
            }
        }
        
        userSelectedFilters.enumerated().forEach { (legIndex, obj) in
            
            let minLayoverDuration = Int(obj.lott.minTime ?? "") ?? 0
            let maxLayoverDuration = Int(obj.lott.maxTime ?? "") ?? 0
            
            outputArray = outputArray.filter { (journey) -> Bool in
                
                if journey.legsWithDetail[legIndex].totalLayOver == 0{
                    return true
                }
                
                if journey.legsWithDetail[legIndex].totalLayOver >= minLayoverDuration && journey.legsWithDetail[legIndex].totalLayOver <= maxLayoverDuration {
                    return true
                }
                
                return false
            }
        }
        
        return outputArray
    }
    
    
    //MARK:- Times ( Departure , Arrival ) Filter
    
    func departureSelectionChangedAt(index : Int,  minDuration: TimeInterval, maxDuration: TimeInterval) {
        
        var departureTimsChanged = false
        var arivalTimeChanged = false
        
        userSelectedFilters[index].dt.setEarliest(time: minDuration)
        userSelectedFilters[index].dt.setLatest(time: maxDuration)
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            let roundedEarliestforInput = TimeInterval(3600.0 * floor(((inputFilter[legIndex].dt.earliestTimeInteval ?? 0)  / 3600 )))
            let roundedLatestforInput = TimeInterval(3600.0 * ceil(((inputFilter[legIndex].dt.latestTimeInterval ?? 0)  / 3600 )))
            let userSelectedEarliest = TimeInterval(3600.0 * floor(((obj.dt.earliestTimeInteval ?? 0)  / 3600 )))
            let userSelectedLatest = TimeInterval(3600.0 * ceil(((obj.dt.latestTimeInterval ?? 0)  / 3600 )))
            return (userSelectedEarliest != roundedEarliestforInput) || (userSelectedLatest != roundedLatestforInput)
        }){
            departureTimsChanged = true
            //            appliedFilters.insert(.Times)
        }else  {
            departureTimsChanged = false
            //            appliedFilters.remove(.Times)
        }
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            let roundedEarliestforInput = TimeInterval(3600.0 * floor(((inputFilter[legIndex].arDt.earliestTimeIntevalWithDate ?? 0)  / 3600 )))
            let roundedLatestforInput = TimeInterval(3600.0 * ceil(((inputFilter[legIndex].arDt.latestTimeIntervalWithDate ?? 0)  / 3600 )))
            let userSelectedEarliest = TimeInterval(3600.0 * floor(((obj.arDt.earliestTimeIntevalWithDate ?? 0)  / 3600 )))
            let userSelectedLatest = TimeInterval(3600.0 * ceil(((obj.arDt.latestTimeIntervalWithDate ?? 0)  / 3600 )))
            return (userSelectedEarliest != roundedEarliestforInput) || (userSelectedLatest != roundedLatestforInput)
        }){
            arivalTimeChanged = true
//            appliedFilters.insert(.Times)
        }else  {
            arivalTimeChanged = false
//            appliedFilters.remove(.Times)
        }
        
//        print("appliedFilters..\(appliedFilters)")
        
        if departureTimsChanged || arivalTimeChanged {
            appliedFilters.insert(.Times)
        }else{
            appliedFilters.remove(.Times)
        }
        
        applyFilters(index: index)
    }
    
    func arrivalSelectionChanged(index : Int, minDate: Date, maxDate: Date) {
        
        var departureTimsChanged = false
        var arivalTimeChanged = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let minDateString = dateFormatter.string(from: minDate)
        let maxDateString = dateFormatter.string(from: maxDate)
        
        userSelectedFilters[index].arDt.earliest = minDateString
        userSelectedFilters[index].arDt.latest = maxDateString
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            let roundedEarliestforInput = TimeInterval(3600.0 * floor(((inputFilter[legIndex].arDt.earliestTimeIntevalWithDate ?? 0)  / 3600 )))
            let roundedLatestforInput = TimeInterval(3600.0 * ceil(((inputFilter[legIndex].arDt.latestTimeIntervalWithDate ?? 0)  / 3600 )))
            let userSelectedEarliest = TimeInterval(3600.0 * floor(((obj.arDt.earliestTimeIntevalWithDate ?? 0)  / 3600 )))
            let userSelectedLatest = TimeInterval(3600.0 * ceil(((obj.arDt.latestTimeIntervalWithDate ?? 0)  / 3600 )))
            return (userSelectedEarliest != roundedEarliestforInput) || (userSelectedLatest != roundedLatestforInput)
        }){
            arivalTimeChanged = true
//            appliedFilters.insert(.Times)
        }else  {
            arivalTimeChanged = false
//            appliedFilters.remove(.Times)
        }
        
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            let roundedEarliestforInput = TimeInterval(3600.0 * floor(((inputFilter[legIndex].dt.earliestTimeInteval ?? 0)  / 3600 )))
            let roundedLatestforInput = TimeInterval(3600.0 * ceil(((inputFilter[legIndex].dt.latestTimeInterval ?? 0)  / 3600 )))
            let userSelectedEarliest = TimeInterval(3600.0 * floor(((obj.dt.earliestTimeInteval ?? 0)  / 3600 )))
            let userSelectedLatest = TimeInterval(3600.0 * ceil(((obj.dt.latestTimeInterval ?? 0)  / 3600 )))
            return (userSelectedEarliest != roundedEarliestforInput) || (userSelectedLatest != roundedLatestforInput)
        }){
            departureTimsChanged = true
            //            appliedFilters.insert(.Times)
        }else  {
            departureTimsChanged = false
            //            appliedFilters.remove(.Times)
        }
        
//        print("appliedFilters..\(appliedFilters)")

            if departureTimsChanged || arivalTimeChanged {
                appliedFilters.insert(.Times)
            }else{
                appliedFilters.remove(.Times)
            }
        
        applyFilters(index: index)
    }
    
    func applyDepartureTimeFilter(index: Int, _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        userSelectedFilters.enumerated().forEach { (legIndex, obj) in
            
            if let minDepartureTime = obj.dt.earliestTimeInteval, let maxDepartureTime = obj.dt.latestTimeInterval{
                
                outputArray = outputArray.filter {
                    
                    let departureTime = $0.legsWithDetail[legIndex].dt
                    let calendar = Calendar.current
                    let startOfDay = calendar.startOfDay(for: Date())
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    dateFormatter.defaultDate = startOfDay
                    guard let date = dateFormatter.date(from: departureTime) else { return  false }
                    let timeInverval = date.timeIntervalSince(startOfDay)
                    
                    return (timeInverval >= minDepartureTime && timeInverval <= maxDepartureTime)
                }
            }
        }
        
        return outputArray
    }
    
    func applyArrivalTimeFilter(index : Int, _ inputArray : [ IntMultiCityAndReturnWSResponse.Results.J]) ->  [ IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        userSelectedFilters.enumerated().forEach { (legIndex, obj) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            if let minDateDate = dateFormatter.date(from: obj.arDt.earliest), let maxDateDate = dateFormatter.date(from: obj.arDt.latest){
                
                outputArray = outputArray.filter {
                    
                    let arrivalDateString = $0.legsWithDetail[legIndex].ad + " " + $0.legsWithDetail[legIndex].at
                    guard let arrivalDate = dateFormatter.date(from: arrivalDateString) else { return false }
                    
                    if arrivalDate >= minDateDate && arrivalDate <= maxDateDate {
                        return true
                    }
                    return false
                }
            }
        }
        
        return outputArray
    }
    
    
    //MARK:- Price Filter
    
    
    func priceSelectionChangedAt(minFare: CGFloat, maxFare: CGFloat) {
        
        userSelectedFilters[0].pr.minPrice = Int(minFare)
        userSelectedFilters[0].pr.maxPrice = Int(maxFare)
        
        if userSelectedFilters[0].pr == inputFilter[0].pr {
            //working fine
            appliedFilters.remove(.Price)
        }else {
            appliedFilters.insert(.Price)
        }
        applyFilters(index: 0)
        
    }
    
    func onlyRefundableFares(selected: Bool) {
        
        if selected {
            UIFilters.insert(.refundableFares)
        }
        else {
            //working fine
            UIFilters.remove(.refundableFares)
        }
        applyFilters(index: 0)
    }
    
    func applyPriceFilter(_ inputArray: [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J]{
        let outputArray = inputArray.filter{  $0.farepr >= userSelectedFilters[0].pr.minPrice && $0.farepr <= userSelectedFilters[0].pr.maxPrice  }
        return outputArray
    }
    

//MARK:- Airport Filters

    func allLayoverSelected(index : Int, isReturnJourney: Bool) {
        self.isReturnJourney = isReturnJourney
        if isReturnJourney {
            let totalAirports = Array(Set(inputFilter[0].loap + inputFilter[1].loap))
            if !userSelectedFilters[0].allLayoversSelected {
                userSelectedFilters[0].loap = totalAirports
            } else {
                userSelectedFilters[0].loap.removeAll()
            }
        } else {
            userSelectedFilters[index].loap = inputFilter[index].loap
        }
        userSelectedFilters[index].allLayoversSelected = !userSelectedFilters[index].allLayoversSelected
        var shouldRemoveLayoverFilter = true
        userSelectedFilters.enumerated().forEach { (index, filter) in
            if (filter.loap.count != inputFilter[index].loap.count && filter.loap.count != 0) || filter.allLayoversSelected {
                shouldRemoveLayoverFilter = false
            }
        }
        if userSelectedFilters[index].allLayoversSelected && !shouldRemoveLayoverFilter {
            UIFilters.insert(.layoverAirports)
        } else if shouldRemoveLayoverFilter {
            UIFilters.remove(.layoverAirports)
        }
        applyFilters(index: index)
    }
    
    func sameSourceDestinationSelected(index: Int) {
        if UIFilters.contains(.originDestinationSame) {
            UIFilters.remove(.originDestinationSame)
        } else {
            UIFilters.insert(.originDestinationSame)
        }
        applyFilters(index: index)
    }
    
    
    func allOriginDestinationAirportsSelected(index : Int) {
        
        UIFilters.remove(.originAirports)
        UIFilters.remove(.destinationAirports)
        
        userSelectedFilters[index].cityapn = inputFilter[index].cityapn
        applyFilters(index: index)
    }
    
    func airportSelectionChangedReturnJourneys(originAiroports: [AirportsGroupedByCity], destinationAirports: [AirportsGroupedByCity]) {
        let origins = originAiroports.reduce([] , { $0 + $1.airports })
        let selectedOrigins = origins.filter{  $0.isSelected == true }
        
        let originAirportsCode = selectedOrigins.map { (airport) -> String in
            airport.IATACode
        }
        
        let destinations = destinationAirports.reduce([] , { $0 + $1.airports })
        let selectedDestinations = destinations.filter{  $0.isSelected == true }
        
        let destinationAirportsCode = selectedDestinations.map { (airport) -> String in
            airport.IATACode
        }
        
//        print(originAirportsCode)
//        print(destinationAirportsCode)
        
        userSelectedFilters[0].cityapn.returnOriginAirports = originAirportsCode
        userSelectedFilters[0].cityapn.returnDestinationAirports = destinationAirportsCode
        
        if selectedOrigins.isEmpty && selectedDestinations.isEmpty {
            UIFilters.remove(.originDestinationSelectedForReturnJourney)
        }else{
            UIFilters.insert(.originDestinationSelectedForReturnJourney)
        }
        
//        print(UIFilters)
        
        applyFilters(index: 0)
    }
    
    func originSelectionChanged(index : Int, selection: [AirportsGroupedByCity]) {
        
        let origins = selection.reduce([] , { $0 + $1.airports })
        let selectedOrigins = origins.filter{  $0.isSelected == true }
        let groupedByCity = Dictionary(grouping: selectedOrigins, by: { $0.city } )
        
        var userSelectedOrigins = [ String : [String]]()
        
        for ( city , journeyArray) in groupedByCity {
            userSelectedOrigins[city] = journeyArray.map{ $0.IATACode }
        }
        
//        print(index)
//        print(userSelectedOrigins)
        
        userSelectedFilters[index].cityapn.fr = userSelectedOrigins
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            
//            print(legIndex)
//            print("obj.cityapn.fr...\(obj.cityapn.fr)")
//            print("inputFilter.cityapn.fr...\(inputFilter[legIndex].cityapn.fr)")
            
            return obj.cityapn.fr != inputFilter[legIndex].cityapn.fr && !obj.cityapn.fr.isEmpty
        }){
            UIFilters.insert(.originAirports)
        }else{
            //working fine
            UIFilters.remove(.originAirports)
        }
        
//        print("UIFilters...\(UIFilters)")
        
        applyFilters(index: index)
        
    }
    
    func applyAirportsFilterForReturnJourneys(inputArray: [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        let selectedOriginAirports = userSelectedFilters[0].cityapn.returnOriginAirports
//        print(selectedOriginAirports)
        
        let selectedDestinationAirports = userSelectedFilters[0].cityapn.returnDestinationAirports
//        print(selectedDestinationAirports)
        
        outputArray = outputArray.filter({ (journey) in
            if selectedOriginAirports.isEmpty && selectedDestinationAirports.isEmpty {
                return true
            } else if selectedOriginAirports.isEmpty {
                return selectedDestinationAirports.contains(journey.legsWithDetail[0].destinationIATACode) && selectedDestinationAirports.contains(journey.legsWithDetail[1].originIATACode)
                
            } else if selectedDestinationAirports.isEmpty {
                return selectedOriginAirports.contains(journey.legsWithDetail[0].originIATACode) && selectedOriginAirports.contains(journey.legsWithDetail[1].destinationIATACode)
            } else {
                return selectedDestinationAirports.contains(journey.legsWithDetail[0].destinationIATACode) && selectedDestinationAirports.contains(journey.legsWithDetail[1].originIATACode) && selectedOriginAirports.contains(journey.legsWithDetail[0].originIATACode) && selectedOriginAirports.contains(journey.legsWithDetail[1].destinationIATACode)
            }
        })
        
        return outputArray
    }
    
    func destinationSelectionChanged(index : Int, selection: [AirportsGroupedByCity]) {
        
        let destinations = selection.reduce([] , { $0 + $1.airports })
        let selectedDestinations = destinations.filter{  $0.isSelected == true }
        let groupedByCity = Dictionary(grouping: selectedDestinations, by: { $0.city } )
        
        var userSelectedDestinations = [ String : [String]]()
        
        for ( city , journeyArray) in groupedByCity {
            userSelectedDestinations[city] = journeyArray.map{ $0.IATACode }
        }
        
        userSelectedFilters[index].cityapn.to = userSelectedDestinations
        if let _ = userSelectedFilters.enumerated().first(where: { (legIndex, obj) -> Bool in
            return obj.cityapn.to != inputFilter[legIndex].cityapn.to && !obj.cityapn.to.isEmpty
        }){
            UIFilters.insert(.destinationAirports)
        }else{
            //working fine
            UIFilters.remove(.destinationAirports)
        }
        applyFilters(index: index)
    }
    
    func layoverSelectionsChanged(index : Int, selection: [LayoverDisplayModel], isReturnJourney: Bool) {
        self.isReturnJourney = isReturnJourney
        let layOvers = selection.reduce([]){ $0 +  $1.airports }
        let selectedLayovers = layOvers.filter{ $0.isSelected == true }
        let selectedLayoverIATACodes = selectedLayovers.map{ $0.IATACode }
        userSelectedFilters[index].loap = selectedLayoverIATACodes
        
        userSelectedFilters[index].allLayoversSelected = selectedLayoverIATACodes.count == inputFilter[index].loap.count
        
        if let _ = userSelectedFilters.enumerated().first(where: { (index, obj) -> Bool in
            return (obj.loap.count != inputFilter[index].loap.count) && !obj.loap.isEmpty
        }){
            UIFilters.insert(.layoverAirports)
        }else{
            //working fine
            UIFilters.remove(.layoverAirports)
        }
        
        if let _ = userSelectedFilters.first(where: { $0.allLayoversSelected }) {
            UIFilters.insert(.layoverAirports)
        }
        
        applyFilters(index: index)
        
    }
    
    func applyOriginFilter(index : Int, _ inputArray: [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        userSelectedFilters.enumerated().forEach { (legIndex, obj) in
            let selectedOrigins = userSelectedFilters[legIndex].cityapn.fr.reduce([]){ $0 +  $1.value }
            let originSet = Set(selectedOrigins)
            if !selectedOrigins.isEmpty{
                outputArray = outputArray.filter{
                    let IATACode = $0.legsWithDetail[legIndex].originIATACode
                    if originSet.contains(IATACode) {
                        return true
                    }
                    return false
                }
            }
        }
        
        return outputArray
    }
    
    
    func applyDestinationFilter(index : Int, _ inputArray: [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        userSelectedFilters.enumerated().forEach { (legIndex, obj) in
            let selectedDestinations = userSelectedFilters[legIndex].cityapn.to.reduce([]){ $0 +  $1.value }
            let destinationSet = Set(selectedDestinations)
            if !selectedDestinations.isEmpty{
                outputArray = outputArray.filter{
                    let IATACode = $0.legsWithDetail[legIndex].destinationIATACode
                    if destinationSet.contains(IATACode) {
                        return true
                    }
                    return false
                }
            }
        }
        
        return outputArray
    }
    
    func applyLayoverFilterForReturn(index : Int, _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        let selectedLayovers = Set(userSelectedFilters[0].loap)
        
        if selectedLayovers.count == 0 {
            return outputArray
        }
        
        outputArray = outputArray.filter {
            let journeyLayovers = Set($0.legsWithDetail[0].loap + $0.legsWithDetail[1].loap)
            if journeyLayovers.count == 0 {
                return false
            }
            if journeyLayovers.isDisjoint(with: selectedLayovers) && !selectedLayovers.isEmpty {
                return false
            }
            return true
        }
        
        return outputArray
    }
    
    
    func applyLayoverFilter(index : Int, _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        userSelectedFilters.enumerated().forEach { (index, filter) in
            let curSelectedFilter = filter
            let selectedLayovers = Set(curSelectedFilter.loap)
            let inputLayovers = Set(inputFilter[index].loap)
            
            if userSelectedFilters[index].allLayoversSelected {
                outputArray = outputArray.filter {
                    let journeyLayovers = Set($0.legsWithDetail[index].loap)
                    if journeyLayovers.isEmpty {
                        return false
                    }
                    return true
                }
            }
            
            if (selectedLayovers.count != inputLayovers.count) && (!selectedLayovers.isEmpty) {
                outputArray = outputArray.filter {
                    let journeyLayovers = Set($0.legsWithDetail[index].loap)
                    if journeyLayovers.isEmpty {
                        return false
                    }
                    if journeyLayovers.isDisjoint(with: selectedLayovers) && !selectedLayovers.isEmpty {
                        return false
                    }
                    return true
                }
            }
        }
        
        return outputArray
        
    }
    
    func applySameOriginDestFilter(index : Int, _ inputArray : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var outputArray = inputArray
        
        outputArray = outputArray.compactMap({ (journey) in
            if journey.legsWithDetail[0].originIATACode == journey.legsWithDetail[1].destinationIATACode && journey.legsWithDetail[0].destinationIATACode == journey.legsWithDetail[1].originIATACode {
                return journey
            }
            return nil
        })
        
        return outputArray
        
    }
    
    
    //MARK:- Flight Quality Filter
    
    
    func qualityFiltersChanged(_ filter : QualityFilter) {
        if filter.isSelected {
            self.UIFilters.insert(filter.filterID)
        }else {
            self.UIFilters.remove(filter.filterID)
        }
        applyFilters(index: 0)
    }
    
    func clearAllFilters() {
        appliedFilters.removeAll()
        UIFilters.removeAll()
        self.userSelectedFilters = inputFilter
        self.filteredJourneyArray = processedJourneyArray
    }
    
    func applyFilters(index : Int) {
        
        // DispatchQueue.global(qos: .background).async {
        
        var inputForFilter = self.processedJourneyArray
        
        for filter in self.appliedFilters {
            
            switch filter {
                
            case .sort:
                continue
            case .stops:
                //Done
                inputForFilter = self.applyStopsFilter(index: index, inputForFilter)
            case .Times:
                //Done
                inputForFilter = self.applyDepartureTimeFilter(index: index, inputForFilter)
                //Done but some issue
                inputForFilter = self.applyArrivalTimeFilter(index: index, inputForFilter)
            case .Duration:
                //Done
                inputForFilter = self.applyDurationFilter(index: index, inputForFilter)
            case .Airlines:
                //Done
                inputForFilter = self.applyAirlineFilter(index: index, inputForFilter)
            case .Airport:
                continue
            case .Quality:
                continue
            case .Price:
                //done
                inputForFilter = self.applyPriceFilter(inputForFilter)
            }
        }
        
        for filter in self.UIFilters {
            
            switch filter {
                
            case .refundableFares:
                //done
                inputForFilter = inputForFilter.filter{
                    
                    $0.rfdPlcy.rfd.first?.value == 1
                }
                
            case .hideLongerOrExpensive:
                continue
            case .hideOvernight:
                //done
                inputForFilter = inputForFilter.filter{$0.ovgtf <= 0 }
                continue
            case .hideChangeAirport:
                //done
                inputForFilter = inputForFilter.filter{ $0.coa == 0 }
                continue
            case .hideOvernightLayover:
                //done
                inputForFilter = inputForFilter.filter{ $0.ovgtlo == 0}
                continue
            case .originAirports:
                //done
                inputForFilter = self.applyOriginFilter(index: index, inputForFilter)
            case .destinationAirports:
                //done
                inputForFilter = self.applyDestinationFilter(index: index, inputForFilter)
            case .layoverAirports:
                //done
                if isReturnJourney {
                    inputForFilter = self.applyLayoverFilterForReturn(index: index, inputForFilter)
                } else {
                    inputForFilter = self.applyLayoverFilter(index: index, inputForFilter)
                }
            case .hideMultiAirlineItinarery:
                inputForFilter = self.applyMultiItinaryAirlineFilter(index: index, inputForFilter)
            case .originDestinationSame:
                inputForFilter = self.applySameOriginDestFilter(index: index, inputForFilter)
            case .originDestinationSelectedForReturnJourney:
                inputForFilter =  applyAirportsFilterForReturnJourneys(inputArray: inputForFilter)
                //                print("originDestinationSelectedForReturnJourney")
            }
        }
        
        self.filteredJourneyArray = inputForFilter
    }
    //}
}

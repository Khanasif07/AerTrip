//
//  FlightResultDisplayGroup +Filters.swift
//  Aertrip
//
//  Created by  hrishikesh on 12/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit



extension FlightResultDisplayGroup  {
    func allAirlinesSelected() {
        
        userSelectedFilters.al = []
        userSelectedFilters.multiAl = 0
        appliedFilters.remove(.Airlines)
        UIFilters.remove(.hideMultiAirlineItinarery)
        applyFilters()
    }
    
    
    
    func hideMultiAirlineItineraryUpdated(_ filter: AirlineLegFilter ) {
        
        if filter.hideMultipleAirline {
            userSelectedFilters.multiAl = 0
            UIFilters.insert(.hideMultiAirlineItinarery)
        }
        else {
            userSelectedFilters.multiAl = 1
            UIFilters.remove(.hideMultiAirlineItinarery)
        }
        applyFilters()
    }
    
    func airlineFilterUpdated(_ filter: AirlineLegFilter) {
        
        let selectedAirlines = filter.airlinesArray.filter{ $0.isSelected }
        let airlineCodesArray = selectedAirlines.map{ $0.code }
        
        userSelectedFilters.al = airlineCodesArray
        
        if userSelectedFilters.al.count > 0 {
            appliedFilters.insert(.Airlines)
        }
        else {
            appliedFilters.remove(.Airlines)
        }
        applyFilters()
        
    }
    
    
    func applyMultiItinaryAirlineFilter( _ inputArray : [Journey]) -> [Journey] {
        
        let hideMultiAirlineItinerary =  userSelectedFilters.multiAl == 1 ? false : true
        if hideMultiAirlineItinerary {
            
            let outputArray = inputArray.filter{
                
                let airlinesSet = Set($0.al)
                if airlinesSet.count > 1 {
                    return false
                }
                return true
            }
            
            return outputArray
        }
        
        return  inputArray
    }
    
    func applyAirlineFilter(_ inputArray : [Journey]) -> [Journey] {
        
        let filteredAirlineSet = Set(userSelectedFilters.al)
        
        var outputArray = inputArray
        
        if filteredAirlineSet.count != 0 {
            
            outputArray = inputArray.filter{
                let journeySet = Set($0.al)
                
                if journeySet.isDisjoint(with:filteredAirlineSet) {
                    return false
                }
                return true
            }
        }
        
        
        return outputArray
    }


//MARK:- Sorting

    func sortFilterChanged(sort: Sort) {
        
        if sort == .Smart {
            appliedFilters.remove(.sort)
        }
        else {
            appliedFilters.insert(.sort)
        }
        
        self.sortOrder = sort
        self.applySort(inputArray: filteredJourneyArray)
    }
    
    func departSortFilterChanged(departMode: Bool) {
        
        appliedFilters.insert(.sort)
        if departMode {
            self.sortOrder = .DurationLatestFirst
        }
        else {
            self.sortOrder = .Depart
        }
  
        self.applySort(inputArray: filteredJourneyArray)
    }
    
    func arrivalSortFilterChanged(arrivalMode: Bool) {
        
        appliedFilters.insert(.sort)
        if arrivalMode {
            self.sortOrder = .ArrivalLatestFirst
        }
        else {
                self.sortOrder = .Arrival
        }
                
        self.applySort(inputArray: filteredJourneyArray)
    }

    
    func applySort( inputArray : [Journey] ) {
        
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

    func stopsSelectionChangedAt( stops: [Int]) {
        let stopsStringsArray = stops.map{ String($0)}
        appliedFilters.insert(.stops)
        userSelectedFilters.stp = stopsStringsArray
        applyFilters()
    }
    
    func allStopsSelected() {
        appliedFilters.remove(.stops)
        applyFilters()
    }
    
    func applyStopsFilter(_ inputArray : [Journey] ) -> [Journey] {
        
        let stopSet = Set(userSelectedFilters.stp)
        let outputArray = inputArray.filter{ stopSet.contains($0.stp) }
        return outputArray
    }


//MARK:- Duration Filter

    
    func tripDurationChanged(min: CGFloat, max: CGFloat) {
        
        var Number = NSNumber(floatLiteral: Double(min * 3600))
        userSelectedFilters.tt.minTime = Number.stringValue
        
        Number = NSNumber(floatLiteral: Double(max * 3600))
        userSelectedFilters.tt.maxTime = Number.stringValue
        
        if userSelectedFilters.tt == inputFilter.tt {
            appliedFilters.remove(.Duration)
        }
        else {
            appliedFilters.insert(.Duration)
        }
        
        applyFilters()
    }
    
    func layoverDurationChanged(min: CGFloat, max: CGFloat) {
        
        var Number = NSNumber(floatLiteral: Double(min * 3600))
        userSelectedFilters.lott?.minTime = Number.stringValue
        
        Number = NSNumber(floatLiteral: Double(max * 3600))
        userSelectedFilters.lott?.maxTime = Number.stringValue
        
        if userSelectedFilters.lott == inputFilter.lott {
            appliedFilters.remove(.Duration)
        }
        else {
            appliedFilters.insert(.Duration)
        }
        
        applyFilters()
    }
    
    func applyDurationFilter(_ inputArray : [Journey] ) -> [Journey] {
        
        var outputArray = inputArray.filter {
            
            let journeyDuration = $0.duration
            
            let minTripDuration = Int(userSelectedFilters.tt.minTime ?? "0" )
            let maxTripDuration = Int(userSelectedFilters.tt.maxTime ?? "0" )
            
            
            if journeyDuration >= minTripDuration! && journeyDuration <= maxTripDuration! {
                return true
            }
            return false
        }
        
        
        outputArray = outputArray.filter {
            
            let journeyLayoverDuration = $0.totalLayOver
            
            let minLayoverDuration = Int(userSelectedFilters.lott?.minTime ?? "0" )
            let maxLayoverDuration = Int(userSelectedFilters.lott?.maxTime ?? "0" )
            
            if journeyLayoverDuration == 0 {
                return true 
            }
            
            if journeyLayoverDuration >= minLayoverDuration! && journeyLayoverDuration <= maxLayoverDuration! {
                return true
            }
            return false
            
        }
        
        return outputArray
    }


//MARK:- Times ( Departure , Arrival ) Filter

    func departureSelectionChangedAt( minDuration: TimeInterval, maxDuration: TimeInterval) {
        
        userSelectedFilters.dt.setEarliest(time: minDuration)
        userSelectedFilters.dt.setLatest(time: maxDuration)
        
        if userSelectedFilters.dt == inputFilter.dt {
            appliedFilters.remove(.Times)
        }
        else {
            appliedFilters.insert(.Times)
        }
        applyFilters()
    }
    
    func arrivalSelectionChanged( minDate: Date, maxDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let minDateString = dateFormatter.string(from: minDate)
        let maxDateString = dateFormatter.string(from: maxDate)
        
        userSelectedFilters.arDt.earliest = minDateString
        userSelectedFilters.arDt.latest = maxDateString
        
        appliedFilters.insert(.Times)
        applyFilters()
    }
    
    func applyDepartureTimeFilter(_ inputArray : [Journey]) -> [Journey] {
        
        guard let minDepartureTime = userSelectedFilters.dt.earliestTimeInteval else { return inputArray}
        guard let maxDepartureTime = userSelectedFilters.dt.latestTimeInterval else { return inputArray}
        
    
        let outputArray = inputArray.filter {
            
            let departureTime = $0.dt
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: Date())
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.defaultDate = startOfDay
            guard let date = dateFormatter.date(from: departureTime) else { return  false }
            let timeInverval = date.timeIntervalSince(startOfDay)
            
            if timeInverval >= minDepartureTime && timeInverval <= maxDepartureTime {
                return true
            }
            return false
        }
        
        return outputArray
    }
    
    
    func applyArrivalTimeFilter( _ inputArray : [ Journey]) ->  [ Journey] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let minDateDate = dateFormatter.date(from: userSelectedFilters.arDt.earliest) else { return inputArray}
        guard let maxDateDate = dateFormatter.date(from: userSelectedFilters.arDt.latest) else { return inputArray}
        
        let outputArray = inputArray.filter {
            
            let arrivalDateString = $0.ad + " " + $0.at
            guard let arrivalDate = dateFormatter.date(from: arrivalDateString) else { return false }
            
            if arrivalDate >= minDateDate && arrivalDate <= maxDateDate {
                return true
            }
            return false
        }
        
        return outputArray
    }


//MARK:- Price Filter

    
    func priceSelectionChangedAt( minFare: CGFloat, maxFare: CGFloat) {
        
        userSelectedFilters.pr.minPrice = Int(minFare)
        userSelectedFilters.pr.maxPrice = Int(maxFare)
        
        if userSelectedFilters.pr == inputFilter.pr {
            appliedFilters.remove(.Price)
        }
        else {
            appliedFilters.insert(.Price)
        }
        applyFilters()
        
    }
    
    func onlyRefundableFares(selected: Bool) {
        
        if selected {
            UIFilters.insert(.refundableFares)
        }
        else {
            UIFilters.remove(.refundableFares)
        }
        applyFilters()
    }
    
    func applyPriceFilter(_ inputArray: [Journey]) -> [Journey]{
        let outputArray = inputArray.filter{  $0.farepr >= userSelectedFilters.pr.minPrice && $0.farepr <= userSelectedFilters.pr.maxPrice  }
        return outputArray
    }


//MARK:- Airport Filters

    func allLayoverSelected() {
        
        userSelectedFilters.loap = [String]()
        UIFilters.remove(.layoverAirports)
        applyFilters()
    }
    
    func sameSourceDestinationSelected() {
        
    }
    
    
    func allOriginDestinationAirportsSelected() {
        
        UIFilters.remove(.originAirports)
        UIFilters.remove(.destinationAirports)
        
        userSelectedFilters.cityapN = inputFilter.cityapN
        applyFilters()
    }
    
    func originSelectionChanged(selection: [AirportsGroupedByCity]) {
        
        let origins = selection.reduce([] , { $0 + $1.airports })
        let selectedOrigins = origins.filter{  $0.isSelected == true }
        let groupedByCity = Dictionary(grouping: selectedOrigins, by: { $0.city } )
        
        var userSelectedOrigins = [ String : [String]]()
        
        for ( city , journeyArray) in groupedByCity {
            userSelectedOrigins[city] = journeyArray.map{ $0.IATACode }
        }
        
        userSelectedFilters.cityapN.fr = userSelectedOrigins
        
        if origins.count == selectedOrigins.count || selectedOrigins.count == 0 {
            UIFilters.remove(.originAirports)
        }
        else {
            UIFilters.insert(.originAirports)
        }
        
        applyFilters()
    }
    
    func destinationSelectionChanged(selection: [AirportsGroupedByCity]) {
        
        
        let destinations = selection.reduce([] , { $0 + $1.airports })
        let selectedDestinations = destinations.filter{  $0.isSelected == true }
        let groupedByCity = Dictionary(grouping: selectedDestinations, by: { $0.city } )
        
        var userSelectedDestinations = [ String : [String]]()
        
        for ( city , journeyArray) in groupedByCity {
            userSelectedDestinations[city] = journeyArray.map{ $0.IATACode }
        }
        
        userSelectedFilters.cityapN.to = userSelectedDestinations
        if destinations.count == selectedDestinations.count || selectedDestinations.count == 0 {
            UIFilters.remove(.destinationAirports)
        }
        else {
            UIFilters.insert(.destinationAirports)
        }
        
        applyFilters()
    }
    
    func layoverSelectionsChanged(selection: [LayoverDisplayModel]) {
        
        
        let layOvers = selection.reduce([]){ $0 +  $1.airports }
        let selectedLayovers = layOvers.filter{ $0.isSelected == true }
        let selectedLayoverIATACodes = selectedLayovers.map{ $0.IATACode}
        
        userSelectedFilters.loap = selectedLayoverIATACodes
        if layOvers.count == selectedLayovers.count || selectedLayovers.count == 0 {
            UIFilters.remove(.layoverAirports)
        }
        else {
            UIFilters.insert(.layoverAirports)
        }
        
        applyFilters()
        
    }
    
    func applyOriginFilter(_ inputArray: [Journey]) -> [Journey] {
        
        let selectedOrigins = userSelectedFilters.cityapN.fr.reduce([]){ $0 +  $1.value }
        let originSet = Set(selectedOrigins)
        if selectedOrigins.count == 0 {
            return inputArray
        }
        
        let outputArray = inputArray.filter{
            
            let IATACode = $0.originIATACode
            if originSet.contains(IATACode) {
                return true
            }
            return false
        }
        return outputArray
    }
    
    
    func applyDestinationFilter(_ inputArray: [Journey]) -> [Journey] {
        
        let selectedDestinations = userSelectedFilters.cityapN.to.reduce([]){ $0 +  $1.value }
        let destinationSet = Set(selectedDestinations)
        if selectedDestinations.count == 0 {
            return inputArray
        }
        
        let outputArray = inputArray.filter{
            
            let IATACode = $0.destinationIATACode
            if destinationSet.contains(IATACode) {
                return true
            }
            return false
        }
        
        return outputArray
    }
    
    func applyLayoverFilter(_ inputArray : [Journey]) -> [Journey] {
        
        let selectedLayovers = Set( userSelectedFilters.loap )
        
        if selectedLayovers.count == 0 {
            return inputArray
        }
        
        let outputArray = inputArray.filter{
            
            let journeyLayovers = Set($0.loap)
            if journeyLayovers.count == 0 {
                return true
            }
            
            
            if journeyLayovers.isDisjoint(with:selectedLayovers) {
                return false
            }
            return true
        }
        
        return outputArray
        
        
    }


//MARK:- Flight Quality Filter

    
    func qualityFiltersChanged(_ filter : QualityFilter) {
        
        if filter.isSelected {
            self.UIFilters.insert(filter.filterID)
        }else {
            self.UIFilters.remove(filter.filterID)
        }
        
        applyFilters()
    }
    
    


    func clearAllFilters() {
        
        appliedFilters.removeAll()
        UIFilters.removeAll()
        self.filteredJourneyArray = processedJourneyArray
    }
    
    
    func applyFilters() {
        
        var inputForFilter = self.processedJourneyArray
        
        for filter in self.appliedFilters {
            
            switch filter {
                
            case .sort:
                continue
            case .stops:
                inputForFilter = self.applyStopsFilter(inputForFilter)
            case .Times:
                inputForFilter = self.applyDepartureTimeFilter(inputForFilter)
                inputForFilter = self.applyArrivalTimeFilter(inputForFilter)
            case .Duration:
                inputForFilter = self.applyDurationFilter(inputForFilter)
            case .Airlines:
                inputForFilter = self.applyAirlineFilter(inputForFilter)
            case .Airport:
                continue
            case .Quality:
                continue
            case .Price:
                inputForFilter = self.applyPriceFilter(inputForFilter)
            }
            
        }
        
        for filter in self.UIFilters {
            
            switch filter {
                
            case .refundableFares:
                inputForFilter = inputForFilter.filter{ $0.rfdPlcy.rfd.first?.value == 1 /*&& $0.leg.first?.fcp != 1 */ }
            case .hideLongerOrExpensive:
                continue
            case .hideOvernight:
                inputForFilter = inputForFilter.filter{$0.ovgtf == 0 }
                continue
            case .hideChangeAirport:
                inputForFilter = inputForFilter.filter{ $0.coa == 0 }
                continue
            case .hideOvernightLayover:
                inputForFilter = inputForFilter.filter{ $0.ovgtlo == 0}
                continue
            case .originAirports:
                inputForFilter = applyOriginFilter(inputForFilter)
            case .destinationAirports:
                inputForFilter = applyDestinationFilter(inputForFilter)
            case .layoverAirports:
                inputForFilter = applyLayoverFilter(inputForFilter)
            case .hideMultiAirlineItinarery:
                inputForFilter = applyMultiItinaryAirlineFilter(inputForFilter)
            case .originDestinationSame:
                continue
            case .originDestinationSelectedForReturnJourney:
                print("originDestinationSelectedForReturnJourney")
            }
        }
        
        DispatchQueue.main.async {
            self.applySort(inputArray: inputForFilter)
        }
    }
}

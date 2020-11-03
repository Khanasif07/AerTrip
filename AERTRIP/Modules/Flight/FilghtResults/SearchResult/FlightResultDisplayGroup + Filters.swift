//
//  FlightResultDisplayGroup +Filters.swift
//  Aertrip
//
//  Created by  hrishikesh on 12/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit



extension FlightResultDisplayGroup  {
    func allAirlinesSelected(selected: Bool) {
        userSelectedFilters?.al = []
        userSelectedFilters?.multiAl = 0
        if selected {
            appliedFilters.insert(.Airlines)
        } else {
            appliedFilters.remove(.Airlines)
        }
        applyFilters()
    }
    
    
    
    func hideMultiAirlineItineraryUpdated(_ filter: AirlineLegFilter ) {
        
        if filter.hideMultipleAirline {
            userSelectedFilters?.multiAl = 0
            UIFilters.insert(.hideMultiAirlineItinarery)
        }
        else {
            userSelectedFilters?.multiAl = 1
            UIFilters.remove(.hideMultiAirlineItinarery)
        }
        applyFilters()
    }
    
    func airlineFilterUpdated(_ filter: AirlineLegFilter) {
        
        let selectedAirlines = filter.airlinesArray.filter{ $0.isSelected }
        let airlineCodesArray = selectedAirlines.map{ $0.code }
        
        userSelectedFilters?.al = airlineCodesArray
        
        if (userSelectedFilters?.al.count ?? 0) > 0 {
            appliedFilters.insert(.Airlines)
        }
        else {
            appliedFilters.remove(.Airlines)
        }
        applyFilters()
        
    }
    
    
    func aircraftFilterUpdated(_ filter: AircraftFilter) {

        self.dynamicFilters.aircraft.selectedAircrafts = filter.selectedAircrafts
        
        if !filter.selectedAircrafts.isEmpty{
            
            appliedFilters.insert(.Aircraft)

        } else {
            
            appliedFilters.remove(.Aircraft)

        }
        
        applyFilters()

        
    }
    
    func applyMultiItinaryAirlineFilter( _ inputArray : [Journey]) -> [Journey] {
        
        let hideMultiAirlineItinerary =  userSelectedFilters?.multiAl == 1 ? false : true
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
      
        var filteredAirlineSet = Set<String>()
        if let airlines = userSelectedFilters?.al {
            filteredAirlineSet = Set(airlines)
        }
        
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

    
    func applyAircraftFilter(_ inputArray : [Journey]) -> [Journey] {

        
        let selectedAircrsfts = Set(self.dynamicFilters.aircraft.selectedAircrafts)
        
         var outputArray = inputArray
         
         if !selectedAircrsfts.isEmpty {
      
             outputArray = inputArray.filter{
                
                let eqs = $0.leg.flatMap { $0.flights }.compactMap { $0.eq }
                
                
                 if Set(eqs).isDisjoint(with:selectedAircrsfts) {
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
//        self.applySort(inputArray: filteredJourneyArray)
    }
    
    
    func priceSortFilterChanged(price:Bool){
        
        appliedFilters.insert(.sort)
        if price {
            self.sortOrder = .PriceHighToLow
        }
        else {
            self.sortOrder = .Price
        }
        
        self.applySort(inputArray: filteredJourneyArray)
    }

    func departSortFilterChanged(departMode: Bool) {
        
        appliedFilters.insert(.sort)
        if departMode {
            self.sortOrder = .DepartLatestFirst
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

    func durationSortFilterChanged(longestFirst: Bool)
    {
        appliedFilters.insert(.sort)
        if longestFirst{
            self.sortOrder = .DurationLongestFirst
        }else{
            self.sortOrder = .Duration
        }
        self.applySort(inputArray: filteredJourneyArray)
    }
    
    func applySort( inputArray : [Journey] ) {
        
        print("applySort=", sortOrder)
        var sortArray = inputArray
        switch  sortOrder {
        case .Price:
            sortArray.sort(by: {$0.price < $1.price})
        case .PriceHighToLow:
            sortArray.sort(by: {$0.price > $1.price})
            
        case .Duration:
            sortArray.sort(by: {$0.duration < $1.duration })
//            sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
            
        case .DurationLongestFirst:
            sortArray.sort(by: {$0.duration > $1.duration })

        case .Smart :
            sortArray.sort(by: {$0.computedHumanScore! < $1.computedHumanScore! })
        case .Depart:
            sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
            sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })

        case .Arrival:
            sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })
            sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })

        case .DepartLatestFirst :
            sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
            sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })

        case .ArrivalLatestFirst :
            sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })
            sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
        }
        
        self.filteredJourneyArray = sortArray
        
    }

    
    func applySortFilter( inputArray : [Journey] ) -> [Journey]{
            
            print("sortOrder=", sortOrder)
            var sortArray = inputArray
            switch  sortOrder {
            case .Price:
                sortArray.sort(by: {$0.price < $1.price})
            case .PriceHighToLow:
                sortArray.sort(by: {$0.price > $1.price})
                
            case .Duration:
                sortArray.sort(by: {$0.duration < $1.duration })
    //            sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
                
            case .DurationLongestFirst:
                sortArray.sort(by: {$0.duration > $1.duration })

            case .Smart :
                sortArray.sort(by: {$0.computedHumanScore! < $1.computedHumanScore! })
            case .Depart:
                sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
                sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })

            case .Arrival:
                sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })
                sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })

            case .DepartLatestFirst :
                sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
                sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })

            case .ArrivalLatestFirst :
                sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })
                sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
            }
            
//            self.filteredJourneyArray = sortArray
            
        return sortArray
        }


//MARK:- Stops Filter

    func stopsSelectionChangedAt( stops: [Int]) {
        let stopsStringsArray = stops.map{ String($0)}
        if stopsStringsArray.isEmpty {
            appliedFilters.remove(.stops)
        } else {
            appliedFilters.insert(.stops)
        }
        if userSelectedFilters != nil{
            userSelectedFilters?.stp = stopsStringsArray
        }
        applyFilters()
    }
    
    func allStopsSelected() {
        appliedFilters.remove(.stops)
        applyFilters()
    }
    
    func applyStopsFilter(_ inputArray : [Journey] ) -> [Journey] {
        let stopSet = Set(userSelectedFilters?.stp ?? [""])
        let outputArray = inputArray.filter{ stopSet.contains($0.stp) }
        return outputArray
    }


//MARK:- Duration Filter

    
    func tripDurationChanged(min: CGFloat, max: CGFloat) {
        
        initiatedFilters.insert(.tripDuration)
        
        var Number = NSNumber(floatLiteral: Double(min * 3600))
        userSelectedFilters?.tt.minTime = Number.stringValue
        
        Number = NSNumber(floatLiteral: Double(max * 3600))
        userSelectedFilters?.tt.maxTime = Number.stringValue
        
        if isDurationFilterApplied() {
            appliedFilters.insert(.Duration)
        } else {
            appliedFilters.remove(.Duration)
        }
        
        applyFilters()
    }
    
    func layoverDurationChanged(min: CGFloat, max: CGFloat) {
        
        initiatedFilters.insert(.layoverDuration)
        
        var Number = NSNumber(floatLiteral: Double(min * 3600))
        userSelectedFilters?.lott?.minTime = Number.stringValue
        
        Number = NSNumber(floatLiteral: Double(max * 3600))
        userSelectedFilters?.lott?.maxTime = Number.stringValue
        
        if isDurationFilterApplied() {
            appliedFilters.insert(.Duration)
        } else {
            appliedFilters.remove(.Duration)
        }
        
        applyFilters()
    }
    
    private func isDurationFilterApplied() -> Bool {
        let totalTimeCheck = isTripDurationFilterApplied()
        let totalLayoverCheck = isLayoverDurationFilterApplied()
        
        if initiatedFilters.contains(.tripDuration) && initiatedFilters.contains(.layoverDuration) {
            return totalTimeCheck || totalLayoverCheck
        } else if initiatedFilters.contains(.tripDuration) {
            return totalTimeCheck
        } else if initiatedFilters.contains(.layoverDuration) {
            return totalLayoverCheck
        }
        return false
    }
    
    private func isTripDurationFilterApplied() -> Bool {
        guard let userSel = userSelectedFilters, let inputFil = inputFilter else { return false }
        
        let userSelectedMinTime = Int(userSel.tt.minTime ?? "") ?? 0,
        userSelectedMaxTime = Int(userSel.tt.maxTime ?? "") ?? 0,
        inputFilterMinTime = Int(inputFil.tt.minTime ?? "") ?? 0,
        inputFilterMaxTime = Int(inputFil.tt.maxTime ?? "") ?? 0
        let totalTimeCheck = !((userSelectedMinTime <= inputFilterMinTime) && (userSelectedMaxTime >= inputFilterMaxTime))
        
        if totalTimeCheck {
            appliedSubFilters.insert(.tripDuration)
        } else {
            appliedSubFilters.remove(.tripDuration)
        }
        return totalTimeCheck
    }
    
    private func isLayoverDurationFilterApplied() -> Bool {
        guard let userSel = userSelectedFilters, let inputFil = inputFilter else { return false }
        
        let userSelectedMinTime = Int(userSel.lott?.minTime ?? "") ?? 0,
        userSelectedMaxTime = Int(userSel.lott?.maxTime ?? "") ?? 0,
        inputFilterMinTime = Int(inputFil.lott?.minTime ?? "") ?? 0,
        inputFilterMaxTime = Int(inputFil.lott?.maxTime ?? "") ?? 0
        let totalTimeCheck = !((userSelectedMinTime <= inputFilterMinTime) && (userSelectedMaxTime >= inputFilterMaxTime))

        if totalTimeCheck {
            appliedSubFilters.insert(.layoverDuration)
        } else {
            appliedSubFilters.remove(.layoverDuration)
        }
        return totalTimeCheck
    }
    
    func applyDurationFilter(_ inputArray : [Journey] ) -> [Journey] {
        
        var outputArray = inputArray
        
        if initiatedFilters.contains(.tripDuration) {
            outputArray = outputArray.filter {
                
                let journeyDuration = $0.duration
                
                var minTripDuration = Int(userSelectedFilters?.tt.minTime ?? "0" ) ?? 0
                var maxTripDuration = Int(userSelectedFilters?.tt.maxTime ?? "0" ) ?? 0
                
                // Check for deep-linking as time comes in hours
                if minTripDuration - 3600 < 0 && maxTripDuration - 3600 < 0 {
                    minTripDuration *= 3600
                    maxTripDuration *= 3600
                }
                
                
                if journeyDuration >= minTripDuration && journeyDuration <= maxTripDuration {
                    return true
                }
                return false
            }
        }
        
        // Layover filter
        if initiatedFilters.contains(.layoverDuration) {
            outputArray = outputArray.filter {
                
                let journeyLayoverDuration = $0.totalLayOver
                
                if journeyLayoverDuration == 0 {
                    return true
                }
                
                var minLayoverDuration = Int(userSelectedFilters?.lott?.minTime ?? "0" ) ?? 0
                var maxLayoverDuration = Int(userSelectedFilters?.lott?.maxTime ?? "0" ) ?? 0
                
                // Check for deep-linking as time comes in hours
                if minLayoverDuration - 3600 < 0 && maxLayoverDuration - 3600 < 0 {
                    minLayoverDuration *= 3600
                    maxLayoverDuration *= 3600
                }
                
                if journeyLayoverDuration >= minLayoverDuration && journeyLayoverDuration <= maxLayoverDuration {
                    return true
                }
                return false
                
            }
        }
        
        return outputArray
    }


//MARK:- Times ( Departure , Arrival ) Filter

    func departureSelectionChangedAt( minDuration: TimeInterval, maxDuration: TimeInterval) {
        
        initiatedFilters.insert(.departureTime)
        
        userSelectedFilters?.dt.setEarliest(time: minDuration)
        userSelectedFilters?.dt.setLatest(time: maxDuration)
        
        if isTimesFilterApplied() {
            appliedFilters.insert(.Times)
        } else {
            appliedFilters.remove(.Times)
        }
        
        applyFilters()
    }
    
    func arrivalSelectionChanged( minDate: Date, maxDate: Date) {
        
        initiatedFilters.insert(.arrivalTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let minDateString = dateFormatter.string(from: minDate)
        let maxDateString = dateFormatter.string(from: maxDate)
        
        userSelectedFilters?.arDt.earliest = minDateString
        userSelectedFilters?.arDt.latest = maxDateString
        
        if isTimesFilterApplied() {
            appliedFilters.insert(.Times)
        } else {
            appliedFilters.remove(.Times)
        }
        
        applyFilters()
    }
    
    private func isTimesFilterApplied() -> Bool {
        let departureCheck = isDepartureTimeFilterApplied()
        let arrivalCheck = isArrivalTimeFilterApplied()
        if initiatedFilters.contains(.departureTime) && initiatedFilters.contains(.arrivalTime) {
            return departureCheck || arrivalCheck
        } else if initiatedFilters.contains(.departureTime) {
            return departureCheck
        } else if initiatedFilters.contains(.arrivalTime) {
            return arrivalCheck
        }
        return false
    }
    
    private func isDepartureTimeFilterApplied() -> Bool {
        guard let userFil = userSelectedFilters, let inputFil = inputFilter else { return false }
        let departFilterCheck = !(userFil.dt.earliest <= inputFil.dt.earliest && userFil.dt.latest >= inputFil.dt.latest)
        if departFilterCheck {
            appliedSubFilters.insert(.departureTime)
        } else {
            appliedSubFilters.remove(.departureTime)
        }
        return departFilterCheck
    }
    
    private func isArrivalTimeFilterApplied() -> Bool {
        guard let userFil = userSelectedFilters, let inputFil = inputFilter else { return false }
        let arrivalFilterCheck = !(userFil.arDt.earliest <= inputFil.arDt.earliest && userFil.arDt.latest >= inputFil.arDt.latest)
        if arrivalFilterCheck {
            appliedSubFilters.insert(.arrivalTime)
        } else {
            appliedSubFilters.remove(.arrivalTime)
        }
        return arrivalFilterCheck
    }
    
    func applyDepartureTimeFilter(_ inputArray : [Journey]) -> [Journey] {
        guard initiatedFilters.contains(.departureTime) else { return inputArray }
        
        guard let minDepartureTime = userSelectedFilters?.dt.earliestTimeInteval else { return inputArray}
        guard var maxDepartureTime = userSelectedFilters?.dt.latestTimeInterval else { return inputArray}
        
        let dateFormatterForDepDt = DateFormatter()
        dateFormatterForDepDt.dateFormat = "yyyy-MM-dd HH:mm"
        let ear = dateFormatterForDepDt.date(from: userSelectedFilters?.depDt.earliest ?? "")?.day ?? 0
        let lat = dateFormatterForDepDt.date(from: userSelectedFilters?.depDt.latest ?? "")?.day ?? 0
        
        if lat - ear > 0 {
            maxDepartureTime = 86400
        }
    
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
        guard let userFil = userSelectedFilters else { return inputArray }
        guard initiatedFilters.contains(.arrivalTime) else { return inputArray }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let minDateDate = dateFormatter.date(from: userFil.arDt.earliest) else { return inputArray}
        guard let maxDateDate = dateFormatter.date(from: userFil.arDt.latest) else { return inputArray}
        
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
        
        userSelectedFilters?.pr.minPrice = Int(minFare)
        userSelectedFilters?.pr.maxPrice = Int(maxFare)
        
        if userSelectedFilters?.pr == inputFilter?.pr {
            UIFilters.remove(.priceRange)
        } else {
            UIFilters.insert(.priceRange)
        }
        
        if userSelectedFilters?.pr == inputFilter?.pr && !UIFilters.contains(.refundableFares) {
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
        
        if (userSelectedFilters?.pr == inputFilter?.pr) && !UIFilters.contains(.refundableFares) {
            appliedFilters.remove(.Price)
        }
        else {
            appliedFilters.insert(.Price)
        }
        
        applyFilters()
    }
    
    func applyPriceFilter(_ inputArray: [Journey]) -> [Journey]{
        guard let userFil = userSelectedFilters, UIFilters.contains(.priceRange) else { return inputArray }
        let outputArray = inputArray.filter{  $0.farepr >= userFil.pr.minPrice && $0.farepr <= userFil.pr.maxPrice  }
        return outputArray
    }


//MARK:- Airport Filters

    func allLayoverSelected(selected: Bool) {
        
        userSelectedFilters?.loap = [String]()
        if selected || UIFilters.contains(.originAirports) || UIFilters.contains(.destinationAirports) {
            UIFilters.insert(.layoverAirports)
            appliedFilters.insert(.Airport)
        } else {
            UIFilters.remove(.layoverAirports)
            appliedFilters.remove(.Airport)
        }
        applyFilters()
    }
    
    func sameSourceDestinationSelected() {
        
    }
    
    
    func allOriginDestinationAirportsSelected() {
        guard let inputFil = inputFilter else { return }
        UIFilters.remove(.originAirports)
        UIFilters.remove(.destinationAirports)
        
        userSelectedFilters?.cityapN = inputFil.cityapN
        
        checkForAirportsFilter()
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
        
        userSelectedFilters?.cityapN.fr = userSelectedOrigins
        
        if origins.count == selectedOrigins.count || selectedOrigins.count == 0 {
            UIFilters.remove(.originAirports)
        }
        else {
            UIFilters.insert(.originAirports)
        }
        checkForAirportsFilter()
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
        
        userSelectedFilters?.cityapN.to = userSelectedDestinations
        if destinations.count == selectedDestinations.count || selectedDestinations.count == 0 {
            UIFilters.remove(.destinationAirports)
        }
        else {
            UIFilters.insert(.destinationAirports)
        }
        checkForAirportsFilter()
        applyFilters()
    }
    
    func layoverSelectionsChanged(selection: [LayoverDisplayModel]) {
        
        
        let layOvers = selection.reduce([]){ $0 +  $1.airports }
        let selectedLayovers = layOvers.filter{ $0.isSelected == true }
        let selectedLayoverIATACodes = selectedLayovers.map{ $0.IATACode}
        
        userSelectedFilters?.loap = selectedLayoverIATACodes
        if selectedLayovers.count == 0 {
            UIFilters.remove(.layoverAirports)
        }
        else {
            UIFilters.insert(.layoverAirports)
        }
        checkForAirportsFilter()
        applyFilters()
        
    }
    
    private func checkForAirportsFilter() {
        if UIFilters.contains(.originAirports) || UIFilters.contains(.destinationAirports) || UIFilters.contains(.layoverAirports) {
            appliedFilters.insert(.Airport)
        } else {
            appliedFilters.remove(.Airport)
        }
    }
    
    func applyOriginFilter(_ inputArray: [Journey]) -> [Journey] {
        guard let userFil = userSelectedFilters else { return inputArray }
        let selectedOrigins = userFil.cityapN.fr.reduce([]){ $0 +  $1.value }
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
        guard let userFil = userSelectedFilters else { return inputArray }
        
        let selectedDestinations = userFil.cityapN.to.reduce([]){ $0 +  $1.value }

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
        guard let userFil = userSelectedFilters else { return inputArray }
        
        let selectedLayovers = Set( userFil.loap )
        
        if selectedLayovers.count == 0 {
            return inputArray
        }
        
//        let outputArray = inputArray.filter{
//
//            let journeyLayovers = Set($0.loap)
//            if journeyLayovers.count == 0 {
//                return true
//            }
//
//
//            if journeyLayovers.isDisjoint(with:selectedLayovers) {
//                return false
//            }
//            return true
//        }
        
        let outputArray = inputArray.filter {
            let totalLayoverAirports = $0.leg.flatMap { $0.loap }
            let journeyLayovers = Set(totalLayoverAirports)
            if journeyLayovers.count == 0 {
                return true
            }
            if journeyLayovers.isDisjoint(with: selectedLayovers) && !selectedLayovers.isEmpty {
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
    
    
    func applyFilters(isAPIResponseUpdated: Bool = false) {
        
        self.isAPIResponseUpdated = isAPIResponseUpdated
        
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
                
            case .Aircraft:
                
                inputForFilter = self.applyAircraftFilter(inputForFilter)

                
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
            case .allAirlinesSelected:
                continue
            case .priceRange:
                continue
            }
        }
        
        self.filteredJourneyArray = inputForFilter
        
//        DispatchQueue.main.async {
//            self.applySort(inputArray: inputForFilter)
//        }
    }
}

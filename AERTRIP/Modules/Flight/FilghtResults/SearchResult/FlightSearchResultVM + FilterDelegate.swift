//
//  FlightSearchResult+FilterDelegate.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 16/05/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

//MARK:- Airline Filter
extension FlightSearchResultVM : AirlineFilterDelegate {
   
    func allAirlinesSelected(_ status: Bool) {
        
        var values = ""
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].allAirlinesSelected(status)
        } else {
            for flightLeg in flightLegs {
                flightLeg.allAirlinesSelected(selected: status)
            }
            let alArr = flightLegs.compactMap { $0.inputFilter?.al }
            let newAl = Array(Set(alArr.flatMap { $0 }))
            
            let alMasterArr = flightResultArray.flatMap { $0.alMaster }
            
            newAl.forEach { (airlineCode) in
                if let airline = alMasterArr.first(where: { $0.key == airlineCode }) {
                    values += "\(airline.value.name), "
                }
            }
            
            if values.suffix(2) == ", " {
                values.removeLast(2)
            }
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Airlines", AnalyticsKeys.FilterType.rawValue : "n/a", AnalyticsKeys.Values.rawValue : values]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        
    }
    
    func hideMultiAirlineItineraryUpdated(_ filter: AirlineLegFilter) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].hideMultiAirlineItineraryUpdated(filter)
            return
        }
        
        for flightLeg in flightLegs {
            flightLeg.hideMultiAirlineItineraryUpdated(filter)
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Airlines", AnalyticsKeys.FilterType.rawValue : "HideMultiItinerary", AnalyticsKeys.Values.rawValue : filter.hideMultipleAirline]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        
    }
   
    func airlineFilterUpdated(_ filter: AirlineLegFilter) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].airlineFilterUpdated(filter)
        } else {
            for flightLeg in flightLegs {
                flightLeg.airlineFilterUpdated(filter)
            }
        }
        
        var values = ""
        filter.airlinesArray.forEach { (airline) in
            if airline.isSelected {
                values += "\(airline.name), "
            }
        }
        
        if values.suffix(2) == ", " {
            values.removeLast(2)
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Airlines", AnalyticsKeys.FilterType.rawValue : "n/a", AnalyticsKeys.Values.rawValue : values]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        
     }
}



//MARK:- Sorting
extension FlightSearchResultVM : SortFilterDelegate {
  
    func resetSort() {
        
    }
    
    func durationSortFilterChanged(longestFirst: Bool) {
        if isIntMCOrReturnJourney {
            return
        }
        
        for flightLeg in flightLegs {
         flightLeg.durationSortFilterChanged(longestFirst: longestFirst)
        }
    }
    
    func sortFilterChanged(sort: Sort ) {
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Sort", AnalyticsKeys.FilterType.rawValue : "Smart", AnalyticsKeys.Values.rawValue : "n/a"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].sortFilterChanged(sort: sort)
            self.delegate?.applySorting(sortOrder: sort, isConditionReverced: true, legIndex: 0)
            return
        }
        
        for (index,flightLeg) in flightLegs.enumerated() {
            flightLeg.sortFilterChanged(sort: sort)
            self.delegate?.applySorting(sortOrder: sort, isConditionReverced: true, legIndex: index)
        }
        
    }
    
    func priceFilterChangedWith(_ highToLow: Bool){
        if isIntMCOrReturnJourney {
            intFlightLegs[0].sortFilterChanged(sort: Sort.Price)
            self.delegate?.applySorting(sortOrder: Sort.Price, isConditionReverced: highToLow, legIndex: 0)
        } else {
            for (index,flightLeg) in flightLegs.enumerated() {
                flightLeg.sortFilterChanged(sort: Sort.Price)
                self.delegate?.applySorting(sortOrder: Sort.Price, isConditionReverced: highToLow, legIndex: index)
            }
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Sort", AnalyticsKeys.FilterType.rawValue : "Price", AnalyticsKeys.Values.rawValue : highToLow ? "High to Low" : "Low to High"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
    }
    
    func durationFilterChangedWith(_ longestFirst: Bool){
        
        if isIntMCOrReturnJourney {
        
            intFlightLegs[0].sortFilterChanged(sort: Sort.Duration)
            self.delegate?.applySorting(sortOrder: Sort.Duration, isConditionReverced: longestFirst, legIndex: 0)
    
        } else {
            
            for (index,flightLeg) in flightLegs.enumerated() {
                flightLeg.sortFilterChanged(sort: Sort.Duration)
                self.delegate?.applySorting(sortOrder: Sort.Duration, isConditionReverced: longestFirst, legIndex: index)
            }
            
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Sort", AnalyticsKeys.FilterType.rawValue : "Duration", AnalyticsKeys.Values.rawValue : longestFirst ? "Longest First" : "Shortest First"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        
    }
    
    
    func departSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool){
        intFlightLegs[0].sortFilterChanged(sort: Sort.Depart)
        self.delegate?.applySorting(sortOrder: Sort.Depart, isConditionReverced: !earliestFirst, legIndex: index)
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Sort", AnalyticsKeys.FilterType.rawValue : "Depart", AnalyticsKeys.Values.rawValue : earliestFirst ? "Earliest First" : "Latest First"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
    }
    
    func arrivalSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool){
        intFlightLegs[0].sortFilterChanged(sort: Sort.Arrival)
        self.delegate?.applySorting(sortOrder: Sort.Arrival, isConditionReverced: !earliestFirst, legIndex: index)
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Sort", AnalyticsKeys.FilterType.rawValue : "Arrival", AnalyticsKeys.Values.rawValue : earliestFirst ? "Earliest First" : "Latest First"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
    }
    
    func departSortFilterChanged(departMode: Bool ) {
        
        if isIntMCOrReturnJourney {
           // intFlightLegs[0].departSortFilterChanged(departMode: departMode)
            return
        }
        
        for (index,flightLeg) in flightLegs.enumerated() {
//         flightLeg.departSortFilterChanged(departMode: departMode)
            
            flightLeg.sortFilterChanged(sort: Sort.Depart)
            self.delegate?.applySorting(sortOrder: Sort.Depart, isConditionReverced: departMode, legIndex: index)
            
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Sort", AnalyticsKeys.FilterType.rawValue : "Depart", AnalyticsKeys.Values.rawValue : departMode ? "Latest First" : "Earliest First"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
    }
    
    func arrivalSortFilterChanged(arrivalMode: Bool ) {
        
        if isIntMCOrReturnJourney {
            //intFlightLegs[0].arrivalSortFilterChanged(arrivalMode: arrivalMode)
            return
        }
        
        for (index,flightLeg) in flightLegs.enumerated() {
//            flightLeg.arrivalSortFilterChanged(arrivalMode: arrivalMode)
            flightLeg.sortFilterChanged(sort: Sort.Arrival)
            self.delegate?.applySorting(sortOrder: Sort.Arrival, isConditionReverced: arrivalMode, legIndex: index)
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Sort", AnalyticsKeys.FilterType.rawValue : "Arrival", AnalyticsKeys.Values.rawValue : arrivalMode ? "Latest First" : "Earliest First"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
    }
}

//MARK:- Stops Filter
extension FlightSearchResultVM :  FlightStopsFilterDelegate {
   
    func stopsSelectionChangedAt(_ index: Int, stops: [Int]) {
        
        // analytics start
        var values = ""
        
        stops.sorted().forEach { (stop) in
            values.append("\(stop) Stops, ")
        }
        if values.suffix(2) == ", " {
            values.removeLast(2)
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Stops", AnalyticsKeys.FilterType.rawValue : "n/a", AnalyticsKeys.Values.rawValue : values]
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        // analytics end
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].stopsSelectionChangedAt(index : index, stops: stops)
            return
        }
        
        flightLegs[index].stopsSelectionChangedAt(stops: stops)
        
    }
    
    func allStopsSelectedAt(_ index: Int) {
        
        // analytics start
        var values = ""
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].allStopsSelected(index)
            
            intFlightLegs[0].inputFilter[index].stp.sorted().forEach { (stop) in
                values.append("\(stop) Stops, ")
            }
            if values.suffix(2) == ", " {
                values.removeLast(2)
            }
    
        } else {
            flightLegs[index].allStopsSelected()
            
            flightLegs[index].inputFilter?.stp.sorted().forEach { (stop) in
                values.append("\(stop) Stops, ")
            }
            if values.suffix(2) == ", " {
                values.removeLast(2)
            }
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Stops", AnalyticsKeys.FilterType.rawValue : "n/a", AnalyticsKeys.Values.rawValue : values]
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        // analytics end
    }
}

//MARK:- Duration Filter
extension FlightSearchResultVM : FlightDurationFilterDelegate {
    
    func tripDurationChangedAt(_ index: Int , min: CGFloat, max: CGFloat) {
        
        var values = ""
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].tripDurationChanged(index: index, min: min, max: max, searchType: bookFlightObject.flightSearchType)
            let tt = intFlightLegs[0].userSelectedFilters[index].tt
            if let min = Int(tt.minTime ?? ""), let max = Int(tt.maxTime ?? "") {
                values += "min\(min/3600)hrs, max\(max/3600)hrs"
            }
        } else {
            flightLegs[index].tripDurationChanged(min: min, max: max)
            
            if let tt = flightLegs[index].userSelectedFilters?.tt {
                if let min = Int(tt.minTime ?? ""), let max = Int(tt.maxTime ?? "") {
                    values += "min\(min/3600)hrs, max\(max/3600)hrs"
                }
            }
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Duration", AnalyticsKeys.FilterType.rawValue : "TripDuration", AnalyticsKeys.Values.rawValue : values]
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        // analytics end
    }
    
    func layoverDurationChangedAt(_ index: Int ,min: CGFloat, max: CGFloat) {
        
        var values = ""
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].layoverDurationChanged(index: index, min: min, max: max, searchType: bookFlightObject.flightSearchType)
            let lott = intFlightLegs[0].userSelectedFilters[index].lott
            if let min = Int(lott.minTime ?? ""), let max = Int(lott.maxTime ?? "") {
                values += "min\(min/3600)hrs, max\(max/3600)hrs"
            }
        } else {
            flightLegs[index].layoverDurationChanged(min: min, max: max)
            if let lott = flightLegs[index].userSelectedFilters?.lott {
                if let min = Int(lott.minTime ?? ""), let max = Int(lott.maxTime ?? "") {
                    values += "min\(min/3600)hrs, max\(max/3600)hrs"
                }
            }
        }
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Duration", AnalyticsKeys.FilterType.rawValue : "LayoverDuration", AnalyticsKeys.Values.rawValue : values]
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        // analytics end
    }
}

//MARK:- Times ( Departure , Arrival ) Filter
extension FlightSearchResultVM : FlightTimeFilterDelegate {
    func departureSelectionChangedAt(_ index: Int, minDuration: TimeInterval, maxDuration: TimeInterval) {
        
        var analyticsValues = ""
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].departureSelectionChangedAt(index : index, minDuration: minDuration, maxDuration: maxDuration)
            
            let dt = intFlightLegs[0].userSelectedFilters[index].dt
            analyticsValues = "min\(dt.earliest), max\(dt.latest)"
        } else {
            flightLegs[index].departureSelectionChangedAt(minDuration: minDuration, maxDuration: maxDuration)
            
            if let dt = flightLegs[index].userSelectedFilters?.dt {
                analyticsValues = "min\(dt.earliest), max\(dt.latest)"
            }
        }
        
        // analytics start
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Times", AnalyticsKeys.FilterType.rawValue : "DepartureTime", AnalyticsKeys.Values.rawValue : analyticsValues]
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        // analytics end
        
    }
    
    func arrivalSelectionChangedAt(_ index: Int, minDate: Date, maxDate: Date) {
        
        var analyticsValues = ""
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].arrivalSelectionChanged(index: index, minDate: minDate, maxDate: maxDate)
            let arDt = intFlightLegs[0].userSelectedFilters[index].arDt
            analyticsValues = "min\(arDt.earliest), max\(arDt.latest)"
        } else {
            flightLegs[index].arrivalSelectionChanged(minDate: minDate, maxDate: maxDate)
            if let arDt = flightLegs[index].userSelectedFilters?.arDt {
                analyticsValues = "min\(arDt.earliest), max\(arDt.latest)"
            }
        }
        
        // analytics start
        
        let eventLogParams: JSONDictionary = [AnalyticsKeys.FilterName.rawValue : "Times", AnalyticsKeys.FilterType.rawValue : "ArrivalTime", AnalyticsKeys.Values.rawValue : analyticsValues]
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: eventLogParams)
        // analytics end
    }

}

//MARK:- Price Filter
extension FlightSearchResultVM : PriceFilterDelegate {
    
    func priceSelectionChangedAt(_ index: Int, minFare: CGFloat, maxFare: CGFloat) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].priceSelectionChangedAt(minFare: minFare, maxFare: maxFare)
            return
        }
        
        flightLegs[index].priceSelectionChangedAt(minFare: minFare, maxFare: maxFare)
    }
    
    func onlyRefundableFares(selected: Bool, index: Int) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].onlyRefundableFares(selected: selected)
            return
        }
        
        flightLegs[index].onlyRefundableFares(selected: selected)
    }
    
}

//MARK:- Airport Filters
extension FlightSearchResultVM : AirportFilterDelegate {
    
    func sameSourceDestinationSelected(at index: Int, selected: Bool) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].sameSourceDestinationSelected(index: index, selected: selected)
            return
        }
        
        flightLegs[index].sameSourceDestinationSelected()
    }
    
    func allLayoverSelectedAt(index: Int, selected: Bool) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].allLayoverSelected(index : index, isReturnJourney: false, selected: selected)
         return
        }
        
        flightLegs[index].allLayoverSelected(selected: selected)
    }
    
    func allLayoversSelectedInReturn(selected: Bool) {
        intFlightLegs[0].allLayoverSelected(index : 0, isReturnJourney: true, selected: selected)
    }
    
    func allOriginDestinationAirportsSelectedAt(index: Int) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].allOriginDestinationAirportsSelected(index : index)
            return
        }
        
        flightLegs[index].allOriginDestinationAirportsSelected()
    }
    
    
    
    func airportSelectionChangedForReturnJourneys(originAirports: [AirportsGroupedByCity], destinationAirports: [AirportsGroupedByCity]) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].airportSelectionChangedReturnJourneys(originAiroports: originAirports, destinationAirports: destinationAirports)
                 return
        } else {
            if flightLegs.indices.contains(0) {
                flightLegs[0].originSelectionChanged(selection: originAirports)
                flightLegs[1].destinationSelectionChanged(selection: originAirports)
            }
            if flightLegs.indices.contains(1) {
                flightLegs[0].destinationSelectionChanged(selection: destinationAirports)
                flightLegs[1].originSelectionChanged(selection: destinationAirports)
            }
        }
        
    }
    
    func originSelectionChanged(selection: [AirportsGroupedByCity], at index: Int) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].originSelectionChanged(index: index, selection: selection)
            return
        }
        
        flightLegs[index].originSelectionChanged(selection: selection)
    }
    
    func destinationSelectionChanged(selection: [AirportsGroupedByCity], at index: Int) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].destinationSelectionChanged(index: index, selection: selection)
            return
        }
        
        flightLegs[index].destinationSelectionChanged(selection: selection)
    }
    
    func layoverSelectionsChanged(selection: [LayoverDisplayModel], at index: Int) {
        
        if isIntMCOrReturnJourney {
            intFlightLegs[0].layoverSelectionsChanged(index: index, selection: selection, isReturnJourney: false)
            return
        }
        
        flightLegs[index].layoverSelectionsChanged(selection: selection)
    }
    
    func layoverSelectionsChangedForReturnJourney(selection: [LayoverDisplayModel], at index: Int) {
        intFlightLegs[0].layoverSelectionsChanged(index: index, selection: selection, isReturnJourney: true)
    }

}

//MARK:- Flight Quality Filter
extension FlightSearchResultVM : QualityFilterDelegate {
    
    func qualityFilterChangedAt(_ index: Int, filter: QualityFilter) {
        if isIntMCOrReturnJourney {
            for leg in intFlightLegs {
                leg.qualityFiltersChanged(filter)
            }
            return
        }
        flightLegs[index].qualityFiltersChanged(filter)
    }
    
    func qualityFiltersChanged(_ filter : QualityFilter) {
        if isIntMCOrReturnJourney {
            for leg in intFlightLegs {
                leg.qualityFiltersChanged(filter)
            }
            return
        }
        
        for flightLeg in flightLegs {
            flightLeg.qualityFiltersChanged(filter)
        }
    }
}

extension FlightSearchResultVM : AircraftFilterDelegate {
 
    func aircraftFilterUpdated(allAircraftsSelected : Bool, _ filter : AircraftFilter) {
        
        
        if isIntMCOrReturnJourney {

            intFlightLegs[0].aircraftFilterUpdated(allAircraftsSelected : allAircraftsSelected ,filter)

            return
        }
        
        for flightLeg in flightLegs {
            
            flightLeg.aircraftFilterUpdated(allAircraftsSelected : allAircraftsSelected , filter)
            
         }
        
        
    }
    
}

extension FlightSearchResultVM : FilterDelegate {
    func clearAllFilters() {
    
        if isIntMCOrReturnJourney {
            intFlightLegs[0].clearAllFilters()
            return
        }
        
        for flightLeg in flightLegs {
            flightLeg.clearAllFilters()
        }
    }
}

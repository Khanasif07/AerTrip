//
//  FlightStopsFilterVM.swift
//  AERTRIP
//
//  Created by Rishabh on 15/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


protocol  FlightStopsFilterDelegate : FilterDelegate {
    func stopsSelectionChangedAt(_ index: Int, stops : [Int])
    func allStopsSelectedAt(_ index: Int)
}


struct StopsFilter{
    var availableStops : [Int]
    var userSelectedStops = [Int]()
    
    var leastStop : Int {
        if availableStops.count > 0 {
            return availableStops.min() ?? 0
        }
        else {
            assertionFailure("Invalid least stops state")
            return -1
        }
    }
    
    var numberofAvailableStops : Int {
        return availableStops.count
    }
    
    var qualityFilter = QualityFilter(name: "Change of Airports", filterKey: "coa", isSelected: false, filterID: .hideChangeAirport)
    
    init( stops : [Int]) {
        availableStops = stops
    }
    
    
    mutating func resetFilter() {
        userSelectedStops.removeAll()
        qualityFilter.isSelected = false
    }
}

class FlightStopsFilterVM {
    
    weak var delegate : FlightStopsFilterDelegate?
    weak var qualityFilterDelegate : QualityFilterDelegate?
    var currentActiveIndex = 0
    var allStopsFilters = [StopsFilter]()
    var currentStopFilter : StopsFilter?
    var allLegNames  = [Leg]()
    var showingForReturnJourney = false
    
    var enableOvernightFlightQualityFilter = [Bool]()
    var isIntMCOrReturnVC = false
    
    func resetFilter() {
        currentStopFilter?.userSelectedStops.removeAll()
        for i in 0 ..< allStopsFilters.count {
            var filter = allStopsFilters[i]
            filter.resetFilter()
            allStopsFilters[i] = filter
        }
    }
    
    func toggleAvoidChangeOfAirports(_ selected: Bool) {
        guard let curFilter = currentStopFilter else { return }
        currentStopFilter?.qualityFilter.isSelected = selected
        allStopsFilters[currentActiveIndex] = curFilter
        
        if isIntMCOrReturnVC {
            allStopsFilters = allStopsFilters.map {
                var newFilter = $0
                newFilter.qualityFilter = curFilter.qualityFilter
                return newFilter
            }
        }
        qualityFilterDelegate?.qualityFilterChangedAt(currentActiveIndex, filter: curFilter.qualityFilter)
    }
}

//
//  FlightDurationFilterVM.swift
//  AERTRIP
//
//  Created by Rishabh on 16/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol  FlightDurationFilterDelegate : FilterDelegate {
    func tripDurationChangedAt(_ index: Int , min: CGFloat , max : CGFloat)
    func layoverDurationChangedAt(_ index: Int , min: CGFloat , max : CGFloat)
}


struct DurationFilter {
    
    var leg : Leg
    var tripDurationMinDuration : CGFloat  = 0.0
    var tripDurationmaxDuration : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var userSelectedTripMin : CGFloat = 0.0
    var userSelectedTripMax : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var layoverMinDuration : CGFloat = 0.0
    var layoverMaxDuration : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var userSelectedLayoverMin : CGFloat = 0.0
    var userSelectedLayoverMax : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var layoverDurationTimeFormat : String = ""
    
    var qualityFilter = QualityFilter(name: "Overnight Layover", filterKey: "ovgtlo", isSelected: false, filterID: .hideOvernightLayover)
    
    init(leg : Leg , tripMin : CGFloat , tripMax : CGFloat , layoverMin : CGFloat , layoverMax : CGFloat, layoverMinTimeFormat:String) {
        
        self.leg = leg
        tripDurationMinDuration = tripMin
        userSelectedTripMin = tripMin
        tripDurationmaxDuration = tripMax
        userSelectedTripMax = tripMax
        
        layoverMinDuration = layoverMin
        userSelectedLayoverMin = layoverMin
        layoverMaxDuration = layoverMax
        userSelectedLayoverMax = layoverMax
        layoverDurationTimeFormat = layoverMinTimeFormat
        
    }
    
    func filterApplied() -> Bool {
        
        if userSelectedTripMin > tripDurationMinDuration {
            return true
        }
        if userSelectedTripMax < tripDurationmaxDuration {
            return true
        }
        
        if userSelectedLayoverMin > layoverMinDuration {
            return true
        }
        
        if layoverMaxDuration > userSelectedLayoverMax {
            return true
        }
        
        if qualityFilter.isSelected {
            return true
        }
        
        return false
    }
    
    mutating func resetFilter() {
        self.userSelectedTripMin = self.tripDurationMinDuration
        self.userSelectedTripMax = self.tripDurationmaxDuration
        self.userSelectedLayoverMin = self.layoverMinDuration
        self.userSelectedLayoverMax = self.layoverMaxDuration
        self.qualityFilter.isSelected = false
    }
}

class FlightDurationFilterVM {
    
    weak var delegate : FlightDurationFilterDelegate?
    weak var qualityFilterDelegate : QualityFilterDelegate?
    var currentDurationFilter : DurationFilter!
    var durationFilters = [DurationFilter]()
    var legsArray = [Leg]()
    var currentActiveIndex = 0
    var showingForReturnJourney = false
    var isFeedBackProvided = false
    
    var tripDurationDiffForFraction: CGFloat {
        let diff = currentDurationFilter.tripDurationmaxDuration - currentDurationFilter.tripDurationMinDuration
        return diff == 0 ? 1 : diff
    }
    
    var layoverDurationDiffForFraction: CGFloat {
        let diff = currentDurationFilter.layoverMaxDuration - currentDurationFilter.layoverMinDuration
        return diff == 0 ? 1 : diff
    }
    
    var isIntMCOrReturnVC = false
    var enableOvernightFlightQualityFilter = [Bool]()
    
    func setInitialValues() {
        currentDurationFilter.userSelectedTripMin = currentDurationFilter.tripDurationMinDuration
        currentDurationFilter.userSelectedTripMax = currentDurationFilter.tripDurationmaxDuration
        currentDurationFilter.userSelectedLayoverMin = currentDurationFilter.layoverMinDuration
        currentDurationFilter.userSelectedLayoverMax = currentDurationFilter.layoverMaxDuration
    }
    
    func setCurrentFilter() {
        currentDurationFilter = durationFilters[currentActiveIndex]
    }

    func getTripDurationMarkerLocations() -> [CGFloat] {
        let minVal = currentDurationFilter.tripDurationMinDuration - currentDurationFilter.tripDurationMinDuration
        let maxVal = currentDurationFilter.tripDurationmaxDuration - currentDurationFilter.tripDurationMinDuration
        let diff = maxVal - minVal
        var markerLocations = [CGFloat]()
        for dayChangeTime in stride(from: 24, through: 240, by: 24) {
            let markLoc = CGFloat(dayChangeTime) - currentDurationFilter.tripDurationMinDuration
            let fraction = markLoc/diff
            guard fraction < 1 else { break }
            markerLocations.append(fraction)
        }
        return markerLocations
    }
    
    func getLayoverDurationMarkerLocations() -> [CGFloat] {
        let minVal = currentDurationFilter.layoverMinDuration - currentDurationFilter.layoverMinDuration
        let maxVal = currentDurationFilter.tripDurationmaxDuration - currentDurationFilter.layoverMinDuration
        let diff = maxVal - minVal
        var markerLocations = [CGFloat]()
        for dayChangeTime in stride(from: 24, through: 240, by: 24) {
            let markLoc = CGFloat(dayChangeTime) - currentDurationFilter.layoverMinDuration
            let fraction = markLoc/diff
            guard fraction < 1 else { break }
            markerLocations.append(fraction)
        }
        return markerLocations
    }
    
}

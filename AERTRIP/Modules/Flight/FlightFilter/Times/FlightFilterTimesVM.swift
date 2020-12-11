//
//  FlightFilterTimesVM.swift
//  AERTRIP
//
//  Created by Rishabh on 11/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol FlightTimeFilterDelegate : FilterDelegate {
    
    func departureSelectionChangedAt(_ index : Int , minDuration : TimeInterval , maxDuration : TimeInterval)
    func arrivalSelectionChangedAt(_ index : Int , minDate : Date , maxDate : Date)
}


extension TimeInterval  {
    static let startOfDay = TimeInterval(0)
    static let sixAM = TimeInterval(6 * 60 * 60)
    static let twelvePM = TimeInterval(12 * 60 * 60)
    static let sixPM = TimeInterval(18 * 60 * 60)
    static let endOfDay = TimeInterval(24 * 60 * 60)
}

class FlightFilterTimesVM {
    
    weak var  delegate : FlightTimeFilterDelegate?
    weak var qualityFilterDelegate : QualityFilterDelegate?
    
    var departureStartTimeInterval : TimeInterval = TimeInterval.startOfDay
    var departureEndTimeInterval : TimeInterval = TimeInterval.endOfDay
    var arrivalInputStartDate : Date!
    var arrivalInputEndDate : Date!
    var multiLegTimerFilter = [FlightLegTimeFilter]()
    
    var currentTimerFilter : FlightLegTimeFilter!
    var currentActiveIndex = 0
    var numberOfLegs = 1
    
    var airportsArr = [AirportLegFilter]()
    var isIntMCOrReturnVC = false

    var arivalDifferenceInSeconds : TimeInterval = 1
    var isHapticFeedbackProvided = false
    var enableOvernightFlightQualityFilter = [Bool]()
    
}

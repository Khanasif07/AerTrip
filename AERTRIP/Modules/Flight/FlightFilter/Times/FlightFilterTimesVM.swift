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
    
    var panStartPos: CGFloat?
    
    func setDepartureSliderValues() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
        
        let startTime = currentTimerFilter.userSelectedStartTime.timeIntervalSince(startOfDay)
        let roundedMinDeparture = 3600.0 * floor(startTime / 3600.0)
        
        departureStartTimeInterval = roundedMinDeparture
        
        let endTime = currentTimerFilter.userSelectedEndTime.timeIntervalSince(startOfDay)
        departureEndTimeInterval = 3600.0 * ceil(endTime / 3600.0)
    }
    
    func handleRightSidePan(minPosNumber: CGFloat, roundedMinDeparture: TimeInterval, roundedMaxDeparture: TimeInterval, curPosNumber: CGFloat) {
        
        switch minPosNumber {
            case 0 :
                if roundedMinDeparture > TimeInterval.startOfDay {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.startOfDay
                }
            case 1 :
                
                if roundedMinDeparture > TimeInterval.sixAM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixAM
                }
            case 2 :
                if roundedMinDeparture > TimeInterval.twelvePM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.twelvePM
                }
            case 3 :
                
                if roundedMinDeparture > TimeInterval.sixPM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixPM
                }
                
            default:
                printDebug("unknown state")
        }
        
        switch curPosNumber {
        case 1 :
            if roundedMaxDeparture < TimeInterval.sixAM  {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixAM
            }
        case 2 :
            if roundedMaxDeparture < TimeInterval.twelvePM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.twelvePM
            }
        case 3 :
            if roundedMaxDeparture < TimeInterval.sixPM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixPM
            }
        case 4 , 5 :
        
            if roundedMaxDeparture < TimeInterval.endOfDay {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.endOfDay
            }
            
        default:
            printDebug("unknown state")
        }
        
    }
    
    func handleLeftSidePan(maxPosNumber: CGFloat, roundedMinDeparture: TimeInterval, roundedMaxDeparture: TimeInterval, curPosNumber: CGFloat) {
        
        switch maxPosNumber {
        case 1 :
            if roundedMaxDeparture < TimeInterval.sixAM  {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixAM
            }
        case 2 :
            if roundedMaxDeparture < TimeInterval.twelvePM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.twelvePM
            }
        case 3 :
            if roundedMaxDeparture < TimeInterval.sixPM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixPM
            }
        case 4 , 5 :
        
            if roundedMaxDeparture < TimeInterval.endOfDay {
                departureEndTimeInterval = roundedMaxDeparture
            }
                else {
                    departureEndTimeInterval = TimeInterval.endOfDay
            }
            
        default:
            printDebug("unknown state")
        }
                
        switch curPosNumber {
            case 0 :
                if roundedMinDeparture > TimeInterval.startOfDay {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.startOfDay
                }
            case 1 :
                
                if roundedMinDeparture > TimeInterval.sixAM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixAM
                }
            case 2 :
                if roundedMinDeparture > TimeInterval.twelvePM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.twelvePM
                }
            case 3 :
                
                if roundedMinDeparture > TimeInterval.sixPM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixPM
                }
                
            default:
                printDebug("unknown state")
        }
    }
    
    func toggleAvoidOvernight(_ selected: Bool) {
        currentTimerFilter.qualityFilter.isSelected = selected
        multiLegTimerFilter[currentActiveIndex] = currentTimerFilter
        
        if isIntMCOrReturnVC {
            multiLegTimerFilter = multiLegTimerFilter.map {
                var newFilter = $0
                newFilter.qualityFilter = currentTimerFilter.qualityFilter
                return newFilter
            }
        }
        qualityFilterDelegate?.qualityFilterChangedAt(currentActiveIndex, filter: currentTimerFilter.qualityFilter)
    }
    
    func getSegmentTitleFor(_ index: Int) -> String {
        let currentFilter = multiLegTimerFilter[(index - 1)]
        let isFilterApplied = currentFilter.filterApplied()
        var title = "\(multiLegTimerFilter[index - 1].leg.origin) \u{279E} \(multiLegTimerFilter[index - 1].leg.destination)"
        if multiLegTimerFilter.count > 3 {
            title = "\(index)"
        }
        var segmentTitle = "\(title) "
        if isFilterApplied {
            segmentTitle = "\(title) •"
        }
        return segmentTitle
    }
}

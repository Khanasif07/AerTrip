//
//  FlightResults+ UI.swift
//  Aertrip
//
//  Created by  hrishikesh on 20/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation


enum ResultTableViewState {
        case showTemplateResults
        case showRegularResults
        case showExpensiveFlights
        case showPinnedFlights
        case showNoResults
}


struct OnewayJourneyResultsArray {
    
    var journeyArray : [JourneyOnewayDisplay] = [] {
        didSet {
            self.allJourneys = journeyArray
            self.suggestedJourneyArray = journeyArray.filter(){
                $0.isAboveHumanScore == false
            }
        }
    }
    
    var allJourneys : [JourneyOnewayDisplay] = []
    var suggestedJourneyArray: [JourneyOnewayDisplay] = []
    var currentPinnedJourneys : [Journey] = []
    var pinnedFlights : [Journey] = []
    var sort : Sort
    var excludeExpensiveFlights = true
    var aboveHumanScoreCount : Int {
    let count = journeyArray.filter() { $0.isAboveHumanScore == true }.reduce(0) { $0 + $1.journeyArray.count }
        return count
    }
    var belowThresholdHumanScore : Int {
        return journeyArray.count - aboveHumanScoreCount
    }
    
    var sortedArray : [Journey] {
        get {
            
    var sortArray = journeyArray.reduce([]) { $0 + $1.journeyArray }

        if excludeExpensiveFlights {
            sortArray =  sortArray.filter() { $0.isAboveHumanScore == false }
        }
            
            switch  sort {
            case .Price:
                sortArray.sort(by: {$0.farepr < $1.farepr})
            case .Duration:
                sortArray.sort(by: {$0.duration < $1.duration })
            case .Smart :
                sortArray.sort(by: {$0.computedHumanScore ?? 0.0 < $1.computedHumanScore ?? 0.0 })
            case .Depart:
                    sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
            case .Arrival:
                    sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })
            case .DurationLongestFirst :
                    sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
            case .ArrivalLatestFirst :
                    sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })
            default: break
            }
            
            return sortArray
        }
    }
}

struct DomesticMultilegJourneyResultsArray {
    
    var journeyArray : [Journey] = [] {
        didSet {
            self.allJourneys = journeyArray
            self.suggestedJourneyArray = journeyArray.filter(){
                $0.isAboveHumanScore == false
            }
        }
    }
    
    var allJourneys : [Journey] = []
    var suggestedJourneyArray: [Journey] = []
    var selectedJourney : Journey?
    var selectesIndex:Int?
    var isJourneySelectedByUser = false
    var sort : Sort
    var excludeExpensiveFlights = true
    var currentPinnedJourneys : [Journey] = []
    var pinnedFlights : [Journey] = []
    
    var aboveHumanScoreCount : Int {
        let count = journeyArray.filter() { $0.isAboveHumanScore == true }.count
        return count
    }
    
    var belowThresholdHumanScore : Int {
        return journeyArray.count - aboveHumanScoreCount
    }
    
    var sortedArray : [Journey] {
        get {
            
            var sortArray = journeyArray
                        
            if excludeExpensiveFlights {
                sortArray = sortArray.filter({ $0.isAboveHumanScore == false })
            }
            
            switch  sort {
            case .Price:
                sortArray.sort(by: {$0.farepr < $1.farepr})
            case .Duration:
                sortArray.sort(by: {$0.duration < $1.duration })
            case .Smart :
                sortArray.sort(by: {$0.computedHumanScore ?? 0.0 < $1.computedHumanScore ?? 0.0 })
            case .Depart:
                    sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
            case .Arrival:
                    sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })
            case .DurationLongestFirst :
                    sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
            case .ArrivalLatestFirst :
                    sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })
            default: break
            }
            
            return sortArray
        }
    }
    
    var containsPinnedFlight : Bool {
        get {
            return journeyArray.reduce(false) {
                return $0 || $1.isPinned ?? false
            }
        }
    }
}


struct InternationalJourneyResultsArray {
    
    var journeyArray : [IntMultiCityAndReturnDisplay]!{
        didSet {
            self.allJourneys = journeyArray
            self.suggestedJourneyArray = journeyArray.filter(){
                $0.isAboveHumanScore == false
            }
        }
    }

    var sort : Sort
    var excludeExpensiveFlights = true
    var suggestedJourneyArray: [IntMultiCityAndReturnDisplay] = []
    var allJourneys : [IntMultiCityAndReturnDisplay] = []
    var currentPinnedJourneys : [IntMultiCityAndReturnWSResponse.Results.J] = []
    var pinnedFlights : [IntMultiCityAndReturnWSResponse.Results.J] = []
    var aboveHumanScoreCount : Int {
        let count = journeyArray.filter() { $0.isAboveHumanScore == true }.reduce(0) { $0 + $1.journeyArray.count }
        return count
    }
    
    var aboveScoreCount : Int {
        let reducedArray = journeyArray.reduce([]) { $0 + $1.journeyArray }
        let filteredArray =  reducedArray.filter() { ($0.isAboveHumanScore ?? false)  }
        return filteredArray.count
       }
    
    var belowThresholdHumanScore : Int {
        return journeyArray.count - aboveHumanScoreCount
    }
    
    mutating func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int){
  
            var sortArray = self.suggestedJourneyArray
        
            if excludeExpensiveFlights {
                    sortArray = journeyArray
            }
            
            self.suggestedJourneyArray = sortArray
            
        }
    
    var sortedArray : [IntMultiCityAndReturnWSResponse.Results.J] {
        get {
            
            var sortArray = journeyArray.reduce([]) { $0 + $1.journeyArray }

            if excludeExpensiveFlights {
               sortArray =  sortArray.filter() { $0.isAboveHumanScore == false }
            }
            
            switch  sort {
            case .Price:
                sortArray.sort(by: {$0.farepr < $1.farepr})
            case .Duration:
                sortArray.sort(by: {$0.duration < $1.duration })
            case .Smart :
                sortArray.sort(by: {$0.computedHumanScore ?? 0.0 < $1.computedHumanScore ?? 0.0 })
            case .Depart:
                    sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
            case .Arrival:
                    sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })
            case .DurationLongestFirst :
                    sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
            case .ArrivalLatestFirst :
                    sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })
            default: break
            }
            
            return sortArray
        }
    }
    
}


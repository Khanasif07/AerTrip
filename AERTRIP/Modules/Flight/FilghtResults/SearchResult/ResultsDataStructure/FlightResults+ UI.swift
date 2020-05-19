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
    
    var journeyArray : [JourneyOnewayDisplay]!
    var sort : Sort
    var excludeExpensiveFlights = true
    
    var suggestedJourneyArray: [JourneyOnewayDisplay]! { get {
        return journeyArray.filter(){ $0.isAboveHumanScore == false }
        }
        set (newJourneyArray){
        }
    }
    
    var expensiveJourneyArray : [JourneyOnewayDisplay]! {
        get {
            return journeyArray.filter(){ $0.isAboveHumanScore == true }
        }
        set(newJourneyArray) {
        }
    }
    
    var pinnedFlights : [Journey] {
        return journeyArray.reduce([]) { $0 + $1.pinnedFlights }
    }
    
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
            
            return sortArray
        }
    }
    
}

struct DomesticMultilegJourneyResultsArray {
    
    var journeyArray : [Journey]!
    var sort : Sort
    var excludeExpensiveFlights = true

    var suggestedJourneyArray: [Journey]! { get {
        return journeyArray.filter(){ $0.isAboveHumanScore == false }
        }
        set (newJourneyArray){
        }
    }
    
    var expensiveJourneyArray : [Journey]! {
        get {
            return journeyArray.filter(){ $0.isAboveHumanScore == true }
        }
        set(newJourneyArray) {
        }
    }
    
    var pinnedFlights : [Journey] {
        return journeyArray.filter{ $0.isPinned  ?? false }
    }
    
    var aboveHumanScoreCount : Int {
        
        let count = journeyArray.filter() { $0.isAboveHumanScore == true }.count
        return count
    }
    
    var belowThresholdHumanScore : Int {
        return journeyArray.count - aboveHumanScoreCount
    }
    
    var sortedArray : [Journey] {
        get {
            
            guard var sortArray = journeyArray else { return journeyArray }
            
            if excludeExpensiveFlights {
                sortArray = sortArray.filter({ $0.isAboveHumanScore == false })
            }
            
            switch  sort {
            case .Price:
                sortArray.sort(by: {$0.farepr < $1.farepr})
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
    
    
//    var expensiveJourneyArray : [IntMultiCityAndReturnDisplay]! {
//        get {
//            return journeyArray.filter(){ $0.isAboveHumanScore == true }
//        }
//        set(newJourneyArray) {
//        }
//    }
    
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
            

//
//            switch  sortOrder {
//            case .Price:
//
//            sortArray.sort(by: { (obj1, obj2) -> Bool in
//
//                if isConditionReverced {
//                    (obj1.journeyArray.first?.price ?? 0) > (obj2.journeyArray.first?.price ?? 0)
//                }else{
//                    (obj1.journeyArray.first?.price ?? 0) < (obj2.journeyArray.first?.price ?? 0)
//                }
//
//                return (obj1.journeyArray.first?.price ?? 0) < (obj2.journeyArray.first?.price ?? 0)
//            })
//
//
//
//            case .Duration:
//                sortArray.sort(by: {$0.duration < $1.duration })
//            case .Smart :
//                sortArray.sort(by: {$0.computedHumanScore! < $1.computedHumanScore! })
//            case .Depart:
//                    sortArray.sort(by: {$0.departTimeInterval < $1.departTimeInterval })
//            case .Arrival:
//                    sortArray.sort(by: {$0.arrivalTimeInteval < $1.arrivalTimeInteval })
//            case .DurationLatestFirst :
//                    sortArray.sort(by: {$0.departTimeInterval > $1.departTimeInterval })
//            case .ArrivalLatestFirst :
//                    sortArray.sort(by: {$0.arrivalTimeInteval > $1.arrivalTimeInteval })
//            }
//
//
            
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
            
            return sortArray
        }
    }
    
}

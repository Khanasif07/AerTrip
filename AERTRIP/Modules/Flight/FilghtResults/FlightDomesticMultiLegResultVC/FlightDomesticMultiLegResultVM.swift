//
//  FlightDomesticMultiLegResultVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 20/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightDomesticMultiLegResultVM {
    
    var showPinnedFlights = false
    var numberOfLegs : Int = 0
    var resultsTableStates =  [ResultTableViewState]()
    var stateBeforePinnedFlight = [ResultTableViewState]()
    var taxesResult : [String : String] = [:]
    var airportDetailsResult : [String : AirportDetailsWS] = [:]
    var airlineDetailsResult : [String : AirlineMasterWS] = [:]
    var airlineCode = ""
    var results = [DomesticMultilegJourneyResultsArray]()
    var sortOrder = Sort.Smart
    let dateFormatter = DateFormatter()
    var prevLegIndex = 0

    var isConditionReverced = false

    init() {
        
    }
    
    func applySorting(tableIndex : Int, sortOrder : Sort, isConditionReverced : Bool, legIndex : Int) {
        
        var suggetedSortArray = self.results[tableIndex].suggestedJourneyArray
        
        var journeySortedArray = self.results[tableIndex].journeyArray
        
        switch  sortOrder {
            
        case .Smart:
            
            suggetedSortArray.sort { (obj1, obj2) -> Bool in
                obj1.computedHumanScore ?? 0.0 < obj2.computedHumanScore ?? 0.0
            }
            
            journeySortedArray = journeySortedArray.sorted(by: { $0.computedHumanScore ?? 0 < $1.computedHumanScore ?? 0 })
            
        case .Price:
            
            suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                
                if isConditionReverced {
                    return obj1.price  > obj2.price
                } else {
                    return obj1.price  < obj2.price
                }
            })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                if isConditionReverced {
                    return obj1.price  > obj2.price
                } else {
                    return obj1.price  < obj2.price
                }
            })
            
            
        case .Duration:
            
            suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                
                if isConditionReverced {
                    return obj1.duration > obj2.duration
                }else{
                    return obj1.duration < obj2.duration
                }
            })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                if isConditionReverced {
                    return obj1.duration > obj2.duration
                }else{
                    return obj1.duration < obj2.duration
                }
            })
            
        case .Depart:
            
            suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = obj1.leg[legIndex].dt
                let secondObjDepartureTime = obj2.leg[legIndex].dt
                
                if isConditionReverced {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }else{
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }
            })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = obj1.leg[legIndex].dt
                let secondObjDepartureTime = obj2.leg[legIndex].dt
                
                if isConditionReverced {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }else{
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }
            })
            
            
            case .Arrival:
                suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                    
                    let firstObjDepartureTime = (obj1.leg[legIndex].ad) + " " + (obj1.leg[legIndex].at)
                    
                    let secondObjDepartureTime = (obj2.leg[legIndex].ad) + " " + (obj2.leg[legIndex].at)
                    
                    let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                    
                    let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                    
                    if isConditionReverced {
                      
                      return firstObjTimeInterval > secondObjTimeInterval

                    }else{
                      
                      return firstObjTimeInterval < secondObjTimeInterval

                    }
                })
                
              journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = (obj1.leg[legIndex].ad) + " " + (obj1.leg[legIndex].at)
                  
                  let secondObjDepartureTime = (obj2.leg[legIndex].ad) + " " + (obj2.leg[legIndex].at)
                  
                  let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                  
                  let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                  
                if isConditionReverced {
                    
                    return firstObjTimeInterval > secondObjTimeInterval

                  } else {
                    
                    return firstObjTimeInterval < secondObjTimeInterval
                    
                  }
                
              })
            
        default: break;
            
        }
        

        self.results[tableIndex].journeyArray = journeySortedArray
        self.results[tableIndex].suggestedJourneyArray = suggetedSortArray
        
    }
    
    
    func getTimeIntervalFromDepartureDateString(dt : String) -> TimeInterval {
        if dt.isEmpty { return  Date().timeIntervalSince1970 }
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.defaultDate = startOfDay
        guard let date = dateFormatter.date(from: dt) else { return  Date().timeIntervalSince1970 }
        return date.timeIntervalSince(startOfDay)
    }
    
    func getTimeIntervalFromArivalDateString(dt : String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let arrivalDate = dateFormatter.date(from: dt) else { return Date() }
        return arrivalDate
    }
    
}

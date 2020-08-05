//
//  FlightResultSingleJourneyVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 30/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightResultSingleJourneyVM {

        var resultTableState  = ResultTableViewState.showTemplateResults {
            didSet {
                print(resultTableState)
            }
    }
        var results : OnewayJourneyResultsArray!
        var isConditionReverced = false
        var prevLegIndex = 0
        var sortOrder = Sort.Smart
        let dateFormatter = DateFormatter()
    
    
    func getOnewayDisplayArray( results : [Journey]) -> [JourneyOnewayDisplay] {
        
        var displayArray = [JourneyOnewayDisplay]()

            if self.resultTableState == .showExpensiveFlights {
             
             let combinedByGroupID = Dictionary(grouping: results, by: { $0.groupID })
             for (_ , journeyArray) in combinedByGroupID {
                 let journey = JourneyOnewayDisplay(journeyArray)
                 
                 // Sort journeys by minimum computed humane score
                 journey.journeyArray.sort { (j1, j2) in
                     let j1Humane = j1.computedHumanScore ?? 0
                     let j2Humane = j2.computedHumanScore ?? 0
                     return j1Humane < j2Humane
                 }
                 
                 displayArray.append(journey)
             }
     
         } else {
             
             let combinedByGroupID = Dictionary(grouping: results, by: { $0.groupID })
             
             for (_ , journeyArray) in combinedByGroupID {
                 let journey = JourneyOnewayDisplay(journeyArray)
                 
                 // Sort journeys by minimum computed humane score
                 journey.journeyArray.sort { (j1, j2) in
                     let j1Humane = j1.computedHumanScore ?? 0
                     let j2Humane = j2.computedHumanScore ?? 0
                     return j1Humane < j2Humane
                 }
                 
                 displayArray.append(journey)
             }
         }
        
         return displayArray
     }
    
    
    func setPinnedFlights(shouldApplySorting : Bool = false) {
          
          var sortArray = self.results.journeyArray.reduce([]) { $0 + $1.pinnedFlights }

          switch  sortOrder {
              
          case .Smart:
                          
              sortArray = sortArray.sorted(by: { $0.computedHumanScore ?? 0 < $1.computedHumanScore ?? 0 })

          case .Price:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  if isConditionReverced {
                      return (obj1.price) > (obj2.price)
                  }else{
                      return (obj1.price) < (obj2.price)
                  }
              })
              
          case .Duration:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  if isConditionReverced {
                      return (obj1.duration) > (obj2.duration)
                  }else{
                      return (obj1.duration) < (obj2.duration)
                  }
              })
              
          case .Depart:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                
                  let firstObjDepartureTime = obj1.leg[self.prevLegIndex].dt
                  let secondObjDepartureTime = obj2.leg[self.prevLegIndex].dt
                  
                  if isConditionReverced {
                      
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                      
                  }else{
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                      
                  }
              })
              
          case .Arrival:
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = (obj1.leg[self.prevLegIndex].ad) + " " + (obj1.leg[self.prevLegIndex].at)
                  
                  let secondObjDepartureTime = (obj2.leg[self.prevLegIndex].ad) + " " + (obj2.leg[self.prevLegIndex].at)
                  
                  let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                  
                  let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                  
                  if isConditionReverced {
                      return firstObjTimeInterval < secondObjTimeInterval
                  }else{
                      return firstObjTimeInterval > secondObjTimeInterval
                  }
              })
              
          default:
              break
              
          }
          
          self.results.pinnedFlights = sortArray
      }
      
      func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int){
       
          var sortArray = self.results.suggestedJourneyArray
              
                 if self.resultTableState == .showExpensiveFlights{
                     sortArray = self.results.journeyArray
                 }
          
          
          switch  sortOrder {
              
          case .Smart:
              
            sortArray = sortArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore })
              
          case .Price:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  if isConditionReverced {
                      return (obj1.journeyArray.first?.price ?? 0) > (obj2.journeyArray.first?.price ?? 0)
                  }else{
                      return (obj1.journeyArray.first?.price ?? 0) < (obj2.journeyArray.first?.price ?? 0)
                  }
              })
              
          case .Duration:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  if isConditionReverced {
                      return (obj1.journeyArray.first?.duration ?? 0) > (obj2.journeyArray.first?.duration ?? 0)
                  }else{
                      return (obj1.journeyArray.first?.duration ?? 0) < (obj2.journeyArray.first?.duration ?? 0)
                  }
              })
              
          case .Depart:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = obj1.journeyArray.first?.leg[self.prevLegIndex].dt
                  let secondObjDepartureTime = obj2.journeyArray.first?.leg[self.prevLegIndex].dt
                  
                  if isConditionReverced {
                      
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime ?? "") < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime ?? "")
                      
                  }else{
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime ?? "") > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime ?? "")
                      
                  }
              })
              
          case .Arrival:
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = (obj1.journeyArray.first?.leg[self.prevLegIndex].ad ?? "") + " " + (obj1.journeyArray.first?.leg[self.prevLegIndex].at ?? "")
                  
                  let secondObjDepartureTime = (obj2.journeyArray.first?.leg[self.prevLegIndex].ad ?? "") + " " + (obj2.journeyArray.first?.leg[self.prevLegIndex].at ?? "")
                  
                  let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                  
                  let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                  
                  if isConditionReverced {
                      return firstObjTimeInterval < secondObjTimeInterval
                  }else{
                      return firstObjTimeInterval > secondObjTimeInterval
                  }
              })
              
              
          default:
              break
              
          }
          
          if self.resultTableState == .showExpensiveFlights{
                  self.results.journeyArray = sortArray
          }else{
                  self.results.suggestedJourneyArray = sortArray
          }
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

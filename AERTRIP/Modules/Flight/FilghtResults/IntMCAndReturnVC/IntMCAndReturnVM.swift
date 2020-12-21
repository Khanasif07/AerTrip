//
//  IntMCAndReturnVM.swift
//  Aertrip
//
//  Created by Appinventiv on 05/05/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation


class IntMCAndReturnVM {
    
    var resultTableState  = ResultTableViewState.showTemplateResults {
        didSet {
            printDebug(resultTableState)
        }
}
    
    var results : InternationalJourneyResultsArray!
    var isConditionReverced = false
    var appliedFilterLegIndex = -1
    var prevLegIndex = 0
    var sortOrder = Sort.Smart
    let dateFormatter = DateFormatter()
    var isSearchByAirlineCode = false
    var flightSearchParameters = JSONDictionary()
    var sharedFks : [String] = []
    var isSharedFkmatched = false

    
    
     func getInternationalDisplayArray( results : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnDisplay] {
        
        var displayArray = [IntMultiCityAndReturnDisplay]()

            if self.resultTableState == .showExpensiveFlights {
             
             let combinedByGroupID = Dictionary(grouping: results, by: { $0.groupID })
             for (_ , journeyArray) in combinedByGroupID {
                 let journey = IntMultiCityAndReturnDisplay(journeyArray)
                 
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
                 let journey = IntMultiCityAndReturnDisplay(journeyArray)
                 
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
        guard results.journeyArray != nil else { return }
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
                
                let firstObjDepartureTime = obj1.legsWithDetail[self.prevLegIndex].dt
                let secondObjDepartureTime = obj2.legsWithDetail[self.prevLegIndex].dt
                
                if isConditionReverced {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }else{
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }
            })
            
        case .Arrival:
            sortArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = (obj1.legsWithDetail[self.prevLegIndex].ad) + " " + (obj1.legsWithDetail[self.prevLegIndex].at)
                
                let secondObjDepartureTime = (obj2.legsWithDetail[self.prevLegIndex].ad) + " " + (obj2.legsWithDetail[self.prevLegIndex].at)
                
                let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                
                let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                
                if isConditionReverced {
                    return firstObjTimeInterval > secondObjTimeInterval
                }else{
                    return firstObjTimeInterval < secondObjTimeInterval
                }
            })
            
        default:
            break
            
        }
        
        self.results.pinnedFlights = sortArray
        self.results.pinnedFlights = self.results.pinnedFlights.removeDuplicates()

    }
    
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int)
    {
        appliedFilterLegIndex = legIndex
     
        var sortArray = self.results.suggestedJourneyArray
            
               if self.resultTableState == .showExpensiveFlights{
                   sortArray = self.results.journeyArray
               }
        
        sortArray.sort(by: { (obj1, obj2) -> Bool in
                return (obj1.journeyArray.first?.price ?? 0) < (obj2.journeyArray.first?.price ?? 0)
        })
        
        
        sortArray.sort(by: { (obj1, obj2) -> Bool in
            
            let firstObjDepartureTime = obj1.journeyArray.first?.legsWithDetail[self.prevLegIndex].dt
            let secondObjDepartureTime = obj2.journeyArray.first?.legsWithDetail[self.prevLegIndex].dt
             
            return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime ?? "") < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime ?? "")
        })
        
        
        sortArray.sort(by: { (obj1, obj2) -> Bool in
            return (obj1.journeyArray.first?.duration ?? 0) < (obj2.journeyArray.first?.duration ?? 0)
        })
        
        
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
                
                let firstObjDepartureTime = obj1.journeyArray.first?.legsWithDetail[self.prevLegIndex].dt
                let secondObjDepartureTime = obj2.journeyArray.first?.legsWithDetail[self.prevLegIndex].dt
                
                if isConditionReverced {
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime ?? "") > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime ?? "")
                }else{
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime ?? "") < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime ?? "")
                }
            })
            
        case .Arrival:
            sortArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = (obj1.journeyArray.first?.legsWithDetail[self.prevLegIndex].ad ?? "") + " " + (obj1.journeyArray.first?.legsWithDetail[self.prevLegIndex].at ?? "")
                
                let secondObjDepartureTime = (obj2.journeyArray.first?.legsWithDetail[self.prevLegIndex].ad ?? "") + " " + (obj2.journeyArray.first?.legsWithDetail[self.prevLegIndex].at ?? "")
                
                let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                
                let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                
                if isConditionReverced {
                    return firstObjTimeInterval > secondObjTimeInterval
                }else{
                    return firstObjTimeInterval < secondObjTimeInterval
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


extension IntMCAndReturnVM{
    
    func generateParam(with journey: IntJourney, trip:TripModel)-> JSONDictionary{
        var param = JSONDictionary()
        let flights = journey.legsWithDetail.flatMap{$0.flightsWithDetails}
        param["trip_id"] = trip.id
        for (index, flight) in flights.enumerated(){
            param["eventDetails[\(index)][airline_code]"] = flight.al
            param["eventDetails[\(index)][depart_airport]"] = flight.fr
            param["eventDetails[\(index)][arrival_airport]"] = flight.to
            param["eventDetails[\(index)][flight_number]"] = flight.fn
            param["eventDetails[\(index)][depart_terminal]"] = flight.dtm
            param["eventDetails[\(index)][arrival_terminal]"] = flight.atm
            param["eventDetails[\(index)][cabin_class]"] = flight.cc
            param["eventDetails[\(index)][depart_dt]"] = flight.dd
            param["eventDetails[\(index)][depart_time]"] = flight.dt
            param["eventDetails[\(index)][arrival_dt]"] = flight.ad
            param["eventDetails[\(index)][arrival_time]"] = flight.at
            param["eventDetails[\(index)][equipment]"] = flight.eq
        }
        param["timezone"] = "Automatic"
        return param
    }
    
    func addToTrip(with journey: IntJourney, trip: TripModel, complition: @escaping((_ success:Bool, _ alreadyAdded: Bool)->())){
        let param = self.generateParam(with: journey, trip: trip)
        APICaller.shared.addToTripFlight(params: param) {(success, error, alreadyAdded) in
            complition(success, alreadyAdded)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
            }
        }
        
    }
    
    
    func setSharedFks() {
        
        guard let dict = flightSearchParameters as? JSONDictionary else { return }
        
        let pfKeys = dict.keys.filter( { $0.contains("PF") } )
               
        pfKeys.forEach { (key) in
            if let fk = dict[key] as? String {
                self.sharedFks.append(fk)
            }
        }

    }
    
    
    func updateRefundStatusInJourneys(fk: String, rfd: Int, rsc: Int) {
        
        self.results.journeyArray.enumerated().forEach { (index,journey) in
            
            if let jourInd = journey.journeyArray.firstIndex(where: { (jour) -> Bool in
                return jour.fk == fk
            }){
         
                self.results.journeyArray[index].journeyArray[jourInd].legsWithDetail.enumerated().forEach { (legInd, leg) in
                    
                    self.results.journeyArray[index].journeyArray[jourInd].legsWithDetail[legInd].fcp = 0
                    
                    self.results.journeyArray[index].journeyArray[jourInd].rfdPlcy.rfd.keys.forEach { (key) in
                        
                        self.results.journeyArray[index].journeyArray[jourInd].rfdPlcy.rfd[key] = rfd
                        
                    }
                    
                }
            }
            
        }
        
        
        self.results.allJourneys.enumerated().forEach { (index,journey) in
            
            if let jourInd = journey.journeyArray.firstIndex(where: { (jour) -> Bool in
                return jour.fk == fk
            }){
         
                self.results.journeyArray[index].journeyArray[jourInd].legsWithDetail.enumerated().forEach { (legInd, leg) in
                    
                    self.results.journeyArray[index].journeyArray[jourInd].legsWithDetail[legInd].fcp = 0
                    
                    self.results.journeyArray[index].journeyArray[jourInd].rfdPlcy.rfd.keys.forEach { (key) in
                            
                            self.results.journeyArray[index].journeyArray[jourInd].rfdPlcy.rfd[key] = rfd
                            
                        }
                }
            }
            
        }
        
        self.results.suggestedJourneyArray.enumerated().forEach { (index,journey) in
            
            if let jourInd = journey.journeyArray.firstIndex(where: { (jour) -> Bool in
                return jour.fk == fk
            }){
         
                self.results.journeyArray[index].journeyArray[jourInd].legsWithDetail.enumerated().forEach { (legInd, leg) in
                    
                    self.results.journeyArray[index].journeyArray[jourInd].legsWithDetail[legInd].fcp = 0
                    
                    self.results.journeyArray[index].journeyArray[jourInd].rfdPlcy.rfd.keys.forEach { (key) in
                            
                            self.results.journeyArray[index].journeyArray[jourInd].rfdPlcy.rfd[key] = rfd
                            
                        }
                }
            }
            
        }
        
        
        if let jourInd = self.results.pinnedFlights.firstIndex(where: { (jour) -> Bool in
                return jour.fk == fk
            
            }){
            
                self.results.pinnedFlights[jourInd].legsWithDetail.enumerated().forEach { (legInd, leg) in
                self.results.pinnedFlights[jourInd].legsWithDetail[legInd].fcp = 0
                            
                    self.results.pinnedFlights[jourInd].rfdPlcy.rfd.keys.forEach { (key) in
                            
                            self.results.pinnedFlights[jourInd].rfdPlcy.rfd[key] = rfd
                            
                        }
            }
         }
        
        
        if let jourInd = self.results.currentPinnedJourneys.firstIndex(where: { (jour) -> Bool in
                 return jour.fk == fk
             
             }){
             
                 self.results.currentPinnedJourneys[jourInd].legsWithDetail.enumerated().forEach { (legInd, leg) in
                 self.results.currentPinnedJourneys[jourInd].legsWithDetail[legInd].fcp = 0
                             
                     self.results.currentPinnedJourneys[jourInd].rfdPlcy.rfd.keys.forEach { (key) in
                                        
                        self.results.currentPinnedJourneys[jourInd].rfdPlcy.rfd[key] = rfd
                                        
                 }
             }
        
        }
        
    }
    
    
}

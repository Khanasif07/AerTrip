//
//  FlightDomesticMultiLegResultVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 20/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightDomesticMultiLegResultVM {
    
    var numberOfLegs : Int = 0
    var resultsTableStates =  [ResultTableViewState](){
        didSet {
            printDebug("resultsTableStates...\(resultsTableStates)")
        }
    }
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
    var isPinnedOn = false
    var isFewSeatsLeft = false
    var shouldDisplayToast = false
    var isSearchByAirlineCode = false
    var flightSearchParameters = JSONDictionary()
    var sharedFks : [String] = []
    var isSharedFkmatched = false
    
    init() {
        
    }
    
    
    func setPinnedFlights(tableIndex : Int) {
          
        var sortArray = self.results[tableIndex].journeyArray.filter { ($0.isPinned ?? false) }

          switch  sortOrder {
              
          case .Smart:
              
              sortArray.sort { (obj1, obj2) -> Bool in
                  obj1.computedHumanScore ?? 0.0 < obj2.computedHumanScore ?? 0.0
              }
                            
          case .Price:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  if isConditionReverced {
                      return obj1.price  > obj2.price
                  } else {
                      return obj1.price  < obj2.price
                  }
              })
              
      
              
              
          case .Duration:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  if isConditionReverced {
                      return obj1.duration > obj2.duration
                  }else{
                      return obj1.duration < obj2.duration
                  }
              })
  
              
          case .Depart:
              
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = obj1.dt
                  let secondObjDepartureTime = obj2.dt
                  
                  if isConditionReverced {
                      
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                      
                  }else{
                      
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                      
                  }
              })
              
     
              
              
              case .Arrival:
                  sortArray.sort(by: { (obj1, obj2) -> Bool in
                      
                      let firstObjDepartureTime = (obj1.ad) + " " + (obj1.at)
                      
                      let secondObjDepartureTime = (obj2.ad) + " " + (obj2.at)
                      
                      let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                      
                      let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                      
                      if isConditionReverced {
                        
                        return firstObjTimeInterval > secondObjTimeInterval

                      }else{
                        
                        return firstObjTimeInterval < secondObjTimeInterval

                      }
                  })
                  
   
              
          default: break;
              
          }
        
        self.results[tableIndex].pinnedFlights = sortArray
          
      }
    
    func applySorting(tableIndex : Int, sortOrder : Sort, isConditionReverced : Bool, legIndex : Int) {
        
        var suggetedSortArray = self.results[tableIndex].suggestedJourneyArray
        
        var journeySortedArray = self.results[tableIndex].journeyArray
        
        suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
            
            return obj1.duration < obj2.duration

        })
        
        journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
            return obj1.duration < obj2.duration
        })
        
        
        suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
            
            let firstObjDepartureTime = obj1.dt
            let secondObjDepartureTime = obj2.dt
                
            return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                
        })
        
        journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
            
            let firstObjDepartureTime = obj1.dt
            let secondObjDepartureTime = obj2.dt
            
            return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                
        })
        
        
        suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                return obj1.farepr  < obj2.farepr
        })
        
        journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                return obj1.farepr  < obj2.farepr
        })
        
        switch  sortOrder {
            
        case .Smart:
            
            suggetedSortArray.sort { (obj1, obj2) -> Bool in
                obj1.computedHumanScore ?? 0.0 < obj2.computedHumanScore ?? 0.0
            }
            
            journeySortedArray = journeySortedArray.sorted(by: { $0.computedHumanScore ?? 0 < $1.computedHumanScore ?? 0 })
            
        case .Price:
            
            suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                
                if isConditionReverced {
                    return obj1.farepr  > obj2.farepr
                } else {
                    return obj1.farepr  < obj2.farepr
                }
            })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                if isConditionReverced {
                    return obj1.farepr  > obj2.farepr
                } else {
                    return obj1.farepr  < obj2.farepr
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
                
                let firstObjDepartureTime = obj1.dt
                let secondObjDepartureTime = obj2.dt
                
                if isConditionReverced {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }else{
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }
            })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = obj1.dt
                let secondObjDepartureTime = obj2.dt
                
                if isConditionReverced {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }else{
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                    
                }
            })
            
            
            case .Arrival:
                suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                    
                    let firstObjDepartureTime = (obj1.ad) + " " + (obj1.at)
                    
                    let secondObjDepartureTime = (obj2.ad) + " " + (obj2.at)
                    
                    let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                    
                    let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                    
                    if isConditionReverced {
                      
                      return firstObjTimeInterval > secondObjTimeInterval

                    }else{
                      
                      return firstObjTimeInterval < secondObjTimeInterval

                    }
                })
                
              journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = (obj1.ad) + " " + (obj1.at)
                  
                  let secondObjDepartureTime = (obj2.ad) + " " + (obj2.at)
                  
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
    
    func currentDataSource(tableIndex : Int) -> [Journey] {
        
        let tableState = self.resultsTableStates[tableIndex]
        var arrayForDisplay = self.results[tableIndex].suggestedJourneyArray

          if tableState == .showPinnedFlights {
             arrayForDisplay = self.results[tableIndex].pinnedFlights
          } else if tableState == .showExpensiveFlights {
             arrayForDisplay = self.results[tableIndex].allJourneys
          } else {
              arrayForDisplay = self.results[tableIndex].suggestedJourneyArray
          }
        
        return arrayForDisplay
         
    }

    
    func selectFlightsInInitialFlow(tableIndex : Int){
        let currentDataSorce = self.currentDataSource(tableIndex: tableIndex)
        if currentDataSorce.isEmpty || self.resultsTableStates[tableIndex] == .showTemplateResults { return }
        self.shouldDisplayToast = false
        if self.results[tableIndex].selectedJourney == nil {
            self.shouldDisplayToast = true
            self.results[tableIndex].selectedJourney = currentDataSorce.first
        } else  {
            
            let selectedJourney = currentDataSorce.filter { $0.fk == self.results[tableIndex].selectedJourney?.fk }
            
            if selectedJourney.isEmpty || !self.results[tableIndex].isJourneySelectedByUser {
                
                if self.results[tableIndex].selectedJourney?.fk != currentDataSorce.first?.fk{
                    self.shouldDisplayToast = true
                }
                
                self.results[tableIndex].selectedJourney = currentDataSorce.first
            }
            
        }
    }
    
    
    func setSelectedJourney(tableIndex : Int, journeyIndex : Int) {
        let currentDataSorce = self.currentDataSource(tableIndex: tableIndex)
        if currentDataSorce.isEmpty || self.resultsTableStates[tableIndex] == .showTemplateResults { return }
        self.results[tableIndex].selectedJourney = currentDataSorce[journeyIndex]
        self.results[tableIndex].selectesIndex = journeyIndex
        self.results[tableIndex].isJourneySelectedByUser = true
     }
    
       func  getSelectedJourneyForAllLegs() -> [Journey]? {
            
            var selectedJourneys = [Journey]()
        
            for index in 0 ..< self.numberOfLegs {
                
    //            let tableResultState = viewModel.resultsTableStates[index]
    //            if tableResultState == .showTemplateResults {  return nil }
                
    //            guard let tableView = baseScrollView.viewWithTag( 1000 + index ) as? UITableView else {
    //                return nil
    //            }
                   
    //            guard let selectedIndex = tableView.indexPathForSelectedRow else {
    //                    return nil }
                    
    //                var currentJourney : Journey
    //                let currentArray : [Journey]
               
                guard let selJour = self.results[index].selectedJourney else {
                    return nil
                }
                selectedJourneys.append(selJour)
                
    //            switch tableResultState {
    //                case .showExpensiveFlights :
    //                        currentArray = self.viewModel.results[index].allJourneys
    //
    //                    if selectedIndex.row < currentArray.count {
    //                        currentJourney = currentArray[selectedIndex.row]
    //                        selectedJourneys.append(currentJourney)
    //                    }
    //                    else {
    //                        return nil
    //                    }
    //                case .showPinnedFlights :
    //
    //                    if selectedIndex.row > self.viewModel.results[index].pinnedFlights.count {
    //                        return nil
    //                    }
    //
    //                    if self.viewModel.results[index].pinnedFlights.count > 0{
    //                        currentJourney = self.viewModel.results[index].pinnedFlights[selectedIndex.row]
    //                        selectedJourneys.append(currentJourney)
    //                    }
    //
    //
    //                case .showRegularResults :
    //
    //                    let suggestedJourneyArray = self.viewModel.results[index].suggestedJourneyArray
    //                    if suggestedJourneyArray.count > 0 {
    //                        currentJourney = self.viewModel.results[index].suggestedJourneyArray[selectedIndex.row]
    //                        selectedJourneys.append(currentJourney)
    //                    }
    //
    //                case .showTemplateResults :
    //                    assertionFailure("Invalid state")
    //                case .showNoResults:
    //                    return nil
    //                }
                
            }
            
            if selectedJourneys.count == self.numberOfLegs {
                return selectedJourneys
            }

            return nil
        }
    
    
    func formatted(fare : Int ) -> String {
         
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
         formatter.maximumFractionDigits = 0
         
         formatter.locale = Locale.init(identifier: "en_IN")
         return formatter.string(from: NSNumber(value: fare)) ?? ""
         
     }
    
    
    func setSharedFks() {
        
        guard let dict = flightSearchParameters as? JSONDictionary else { return }
        
        let pfKeys = dict.keys.filter( { $0.contains("PF") } )
       
        printDebug("pfKeys...\(pfKeys)")
        
        pfKeys.forEach { (key) in
            if let fk = dict[key] as? String {
                self.sharedFks.append(fk)
            }
        }

    }
    
    func addToTrip(with journey: Journey, trip: TripModel, complition: @escaping((_ success:Bool, _ alreadyAdded: Bool)->())){
        let param = self.generateParam(with: journey, trip: trip)
        APICaller.shared.addToTripFlight(params: param) {(success, error, alreadyAdded) in
            complition(success, alreadyAdded)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
            }
        }

    }
    
    func generateParam(with journey: Journey, trip:TripModel)-> JSONDictionary{
        var param = JSONDictionary()
        let flights = journey.leg.flatMap{$0.flights}
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
    
    
}

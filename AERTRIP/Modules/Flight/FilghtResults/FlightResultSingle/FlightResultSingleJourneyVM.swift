//
//  FlightResultSingleJourneyVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 30/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightResultSingleJourneyVM {
    
        var titleString : NSAttributedString!
        var subtitleString : String!
        var airportDetailsResult : [String : AirportDetailsWS]!
        var airlineDetailsResult : [String : AirlineMasterWS]!
        var taxesResult : [String : String]!
        var sid : String = ""
        var bookFlightObject = BookFlightObject()
        var scrollviewInitialYOffset = CGFloat(0.0)
        var flightSearchResultVM  : FlightSearchResultVM!
        var userSelectedFilters = [FiltersWS]()
        var updatedApiProgress : Float = 0
        var apiProgress : Float = 0
    
        var resultTableState  = ResultTableViewState.showTemplateResults {
            didSet {
                printDebug(resultTableState)
            }
        }
    
    var stateBeforePinnedFlight = ResultTableViewState.showRegularResults
    var results : OnewayJourneyResultsArray!
        var isConditionReverced = false
//        var prevLegIndex = 0
        var sortOrder = Sort.Smart
        let dateFormatter = DateFormatter()
    
        var airlineCode = ""
    
        var isSearchByAirlineCode = false
    
        var flightSearchParameters = JSONDictionary()
        var sharedFks : [String] = []
        var isSharedFkmatched = false
        var contentOffset : CGPoint?
    
    let getSharableLink = GetSharableUrl()


    
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
                
                  let firstObjDepartureTime = obj1.leg[0].dt
                  let secondObjDepartureTime = obj2.leg[0].dt
                  
                  if isConditionReverced {
                    
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                      
                  } else {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)
                      
                  }
              })
              
          case .Arrival:
              sortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = (obj1.leg[0].ad) + " " + (obj1.leg[0].at)
                  
                  let secondObjDepartureTime = (obj2.leg[0].ad) + " " + (obj2.leg[0].at)
                  
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
          self.results.pinnedFlights.removeDuplicates()

        printDebug("self.results.currentPinnedJourneys.count...\(self.results.currentPinnedJourneys.count)")

        printDebug("self.results.pinnedFlights.count...\(self.results.pinnedFlights.count)")
        
      }
      
    
    func applySortingOnGroups(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int) {
     
//        let journeyArrayToSort = self.results.journeyArray
        
        for (index,_) in self.results.journeyArray.enumerated() {
                        
            if self.results.journeyArray[index].journeyArray.count > 1 {
            
                //smart sort
                self.results.journeyArray[index].journeyArray.sort(by: { $0.computedHumanScore ?? 0.0 < $1.computedHumanScore ?? 0.0 })
                
                //arival sort
                self.results.journeyArray[index].journeyArray.sort(by: { (obj1, obj2) -> Bool in
                               
                    let firstObjDepartureTime = (obj1.ad) + " " + (obj1.at)
                               
                               let secondObjDepartureTime = (obj2.ad) + " " + (obj2.at)
                               
                               let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                               
                               let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)

                                 return firstObjTimeInterval < secondObjTimeInterval

                           })

                //departure sort
                self.results.journeyArray[index].journeyArray.sort(by: { (obj1, obj2) -> Bool in
                    
                    let firstObjDepartureTime = obj1.dt
                    let secondObjDepartureTime = obj2.dt
                    
                      return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)

                })
                
                                
                // SET SELECTED JOURNEY ON THE BASIS OF APPLIED SORT
                
                switch sortOrder {
                    
                       case .Smart, .Price :
                           
                           if let ind = self.results.journeyArray[index].journeyArray.firstIndex(where: { (jrny) -> Bool in
                            jrny.fk == self.results.journeyArray[index].getJourneyWithLeastHumanScore()?.fk
                           }){
                            
                            self.results.journeyArray[index].selectedFK = self.results.journeyArray[index].journeyArray[ind].fk
                            self.results.journeyArray[index].currentSelectedIndex = ind
                            
                           }
                           
                       case .Duration:
                           
                           if isConditionReverced {
                               
                               guard let jour = self.results.journeyArray[index].getJourneysWithMaxDuration() else { return }
                               self.results.journeyArray[index].selectedFK = jour.fk
                                  
                               if let ind = self.results.journeyArray[index].journeyArray.firstIndex(where: { (jrny) -> Bool in
                                   jrny.fk == jour.fk
                               }){
                                   self.results.journeyArray[index].selectedFK = self.results.journeyArray[index].journeyArray[ind].fk
                                self.results.journeyArray[index].currentSelectedIndex = ind
                               }
                               
                           } else {
                               
                               guard let jour = self.results.journeyArray[index].getJourneysWithMinDuration() else { return }
                               self.results.journeyArray[index].selectedFK = jour.fk
                                            
                               if let ind = self.results.journeyArray[index].journeyArray.firstIndex(where: { (jrny) -> Bool in
                                   jrny.fk == jour.fk
                               }){
                                   self.results.journeyArray[index].selectedFK = self.results.journeyArray[index].journeyArray[ind].fk
                                self.results.journeyArray[index].currentSelectedIndex = ind
                               }
                           }
                           
                       case .Depart:
                           
                           if isConditionReverced {
                               self.results.journeyArray[index].selectedFK = self.results.journeyArray[index].journeyArray.last?.fk ?? ""
                            self.results.journeyArray[index].currentSelectedIndex = self.results.journeyArray[index].journeyArray.count - 1
                           }else{
                               self.results.journeyArray[index].selectedFK = self.results.journeyArray[index].journeyArray.first?.fk ?? ""
                            self.results.journeyArray[index].currentSelectedIndex = 0
                           }
                           
                       case .Arrival:
                           
                           if isConditionReverced {
                               
                               guard let jour = self.results.journeyArray[index].getJourneysWithMaxArivalTime() else { return }
                               self.results.journeyArray[index].selectedFK = jour.fk
                               
                               if let ind = self.results.journeyArray[index].journeyArray.firstIndex(where: { (jrny) -> Bool in
                                   jrny.fk == jour.fk
                               }){
                                   self.results.journeyArray[index].selectedFK = self.results.journeyArray[index].journeyArray[ind].fk
                                self.results.journeyArray[index].currentSelectedIndex = ind
                               }
                               
                           } else{
                               
                               guard let jour = self.results.journeyArray[index].getJourneysWithMinArivalTime() else { return }
                               self.results.journeyArray[index].selectedFK = jour.fk
                                             
                               if let ind = self.results.journeyArray[index].journeyArray.firstIndex(where: { (jrny) -> Bool in
                                   jrny.fk == jour.fk
                               }){
                                   self.results.journeyArray[index].selectedFK = self.results.journeyArray[index].journeyArray[ind].fk
                                self.results.journeyArray[index].currentSelectedIndex = ind
                               }
                           }
                           
                       default:
                           break
                       }
           }
        }
        
//        self.results.journeyArray = journeyArrayToSort
        
    }
    
    
      func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int){
       
          var suggetedSortArray = self.results.suggestedJourneyArray
                
          var journeySortedArray = self.results.journeyArray

        
        suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
          
            let duration1 = (obj1.journeyArray[safe : obj1.currentSelectedIndex]?.duration) ?? 0
            
            let duration2 = (obj2.journeyArray[safe : obj2.currentSelectedIndex]?.duration) ?? 0
            
            return duration1 < duration2
        })
      
      journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
      
        let duration1 = (obj1.journeyArray[safe : obj1.currentSelectedIndex]?.duration) ?? 0
        let duration2 = (obj2.journeyArray[safe : obj2.currentSelectedIndex]?.duration) ?? 0
        
        return duration1 < duration2

            })
        
        
        
        suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
            
            let firstObjDepartureTime = (obj1.journeyArray[safe : obj1.currentSelectedIndex]?.leg.first?.dt) ?? ""
         
            let secondObjDepartureTime = (obj2.journeyArray[safe : obj2.currentSelectedIndex]?.leg.first?.dt) ?? ""
            
            return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)

        })
      
      journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
          
        let firstObjDepartureTime = (obj1.journeyArray[safe : obj1.currentSelectedIndex]?.leg.first?.dt) ?? ""
     
        let secondObjDepartureTime = (obj2.journeyArray[safe : obj2.currentSelectedIndex]?.leg.first?.dt) ?? ""
          
        return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)

      })
        
        
        suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                 
            let price1 = (obj1.journeyArray[safe : obj1.currentSelectedIndex]?.price) ?? 0
            
            let price2 = (obj2.journeyArray[safe : obj2.currentSelectedIndex]?.price) ?? 0
            
            return price1 < price2
        })
      
      journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
       
        
        let price1 = (obj1.journeyArray[safe : obj1.currentSelectedIndex]?.price) ?? 0
        
        let price2 = (obj2.journeyArray[safe : obj2.currentSelectedIndex]?.price) ?? 0
        
        return price1 < price2

           })

        
          switch  sortOrder {
              
          case .Smart:
              
            suggetedSortArray = suggetedSortArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore })
            
            journeySortedArray = journeySortedArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore })

          case .Price:
              
              suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                  if isConditionReverced {
                    return (obj1.journeyArray[obj1.currentSelectedIndex].price) > (obj2.journeyArray[obj2.currentSelectedIndex].price)
                  }else{
                    return (obj1.journeyArray[obj1.currentSelectedIndex].price) < (obj2.journeyArray[obj2.currentSelectedIndex].price)
                  }
              })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                     if isConditionReverced {
                        return (obj1.journeyArray[obj1.currentSelectedIndex].price) > (obj2.journeyArray[obj2.currentSelectedIndex].price)
                     }else{
                        return (obj1.journeyArray[obj1.currentSelectedIndex].price) < (obj2.journeyArray[obj2.currentSelectedIndex].price)
                     }
                 })
                 
              
          case .Duration:
              
              suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                  if isConditionReverced {
                      return (obj1.journeyArray[obj1.currentSelectedIndex].duration) > (obj2.journeyArray[obj2.currentSelectedIndex].duration)
                  }else{
                      return (obj1.journeyArray[obj1.currentSelectedIndex].duration) < (obj2.journeyArray[obj2.currentSelectedIndex].duration)
                  }
              })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                      if isConditionReverced {
                          return (obj1.journeyArray[obj1.currentSelectedIndex].duration) > (obj2.journeyArray[obj2.currentSelectedIndex].duration)
                      }else{
                          return (obj1.journeyArray[obj1.currentSelectedIndex].duration) < (obj2.journeyArray[obj2.currentSelectedIndex].duration)
                      }
                  })
              
          case .Depart:
              
              suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                let firstObjDepartureTime = obj1.journeyArray[obj1.currentSelectedIndex].leg[0].dt
                let secondObjDepartureTime = obj2.journeyArray[obj2.currentSelectedIndex].leg[0].dt
                  
                  if isConditionReverced {
                      
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)

                  }else{
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)

                  }
              })
            
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = obj1.journeyArray[obj1.currentSelectedIndex].leg[0].dt
                let secondObjDepartureTime = obj2.journeyArray[obj2.currentSelectedIndex].leg[0].dt
                
                if isConditionReverced {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)

                  
                }else{
                  
                  return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime) < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime)

                    
                }
            })
              
          case .Arrival:
              suggetedSortArray.sort(by: { (obj1, obj2) -> Bool in
                  
                  let firstObjDepartureTime = (obj1.journeyArray[obj1.currentSelectedIndex].leg[0].ad) + " " + (obj1.journeyArray[obj1.currentSelectedIndex].leg[0].at)
                  
                  let secondObjDepartureTime = (obj2.journeyArray[obj2.currentSelectedIndex].leg[0].ad) + " " + (obj2.journeyArray[obj2.currentSelectedIndex].leg[0].at)
                  
                  let firstObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                  
                  let secondObjTimeInterval = self.getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                  
                  if isConditionReverced {
                    
                    return firstObjTimeInterval > secondObjTimeInterval

                    
                  }else{
                    
                    return firstObjTimeInterval < secondObjTimeInterval

                  }
              })
              
            journeySortedArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = (obj1.journeyArray[obj1.currentSelectedIndex].leg[0].ad) + " " + (obj1.journeyArray[obj1.currentSelectedIndex].leg[0].at)
                
                let secondObjDepartureTime = (obj2.journeyArray[obj2.currentSelectedIndex].leg[0].ad) + " " + (obj2.journeyArray[obj2.currentSelectedIndex].leg[0].at)
                
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
        
        self.results.journeyArray = journeySortedArray
        self.results.suggestedJourneyArray = suggetedSortArray

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

extension FlightResultSingleJourneyVM{
    
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
    
    func addToTrip(with journey: Journey, trip: TripModel, complition: @escaping((_ success:Bool, _ alreadyAdded: Bool)->())){
        let param = self.generateParam(with: journey, trip: trip)
        APICaller.shared.addToTripFlight(params: param) {(success, error, alreadyAdded) in
            complition(success, alreadyAdded)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
            }
        }

    }
    
    
    func setSharedFks(){
        
        guard let dict = flightSearchParameters as? JSONDictionary else { return }
        
        let pfKeys = dict.keys.filter( { $0.contains("PF") } )
       
        printDebug("pfKeys...\(pfKeys)")
        
        pfKeys.forEach { (key) in
            if let fk = dict[key] as? String {
                self.sharedFks.append(fk)
            }
        }

    }
    
    
}

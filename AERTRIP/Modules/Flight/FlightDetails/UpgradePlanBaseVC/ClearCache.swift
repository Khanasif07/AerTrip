//
//  ClearCache.swift
//  Aertrip
//
//  Created by Monika Sonawane on 09/01/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

class ClearCache: NSObject
{
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    func checkTimeAndClearUpgradeDataCache(){
//        if appdelegate.upgradeDataMutableArray != nil{
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
                if i < appdelegate.upgradeDataMutableArray.count{
                    if let ass = self.appdelegate.upgradeDataMutableArray[i] as? JSONDictionary
                    {
                        let storedTime = ass["Time"] as? String ?? ""
                        
                        let currTime = "\(hour):\(minutes):\(seconds)"
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        let formatedStoredTime = dateFormatter.date(from:storedTime)
                        let formatedCurrTime = dateFormatter.date(from:currTime)
                        
                        let calendarFormat = NSCalendar.current
                        guard let formatedStoredTime1 = formatedStoredTime, let formatedCurrTime1 = formatedCurrTime, let next3MinutesTime = calendarFormat.date(byAdding: .minute, value: 3, to: formatedStoredTime1) else {return }
                        
                        if formatedCurrTime1 > next3MinutesTime{
                            self.appdelegate.upgradeDataMutableArray.removeObject(at: i)
                        }
                    }
                }
            }
//        }
    }
    
    func checkTimeAndClearFlightPerformanceResultCache(journey: [Journey]?){
        //        if appdelegate.flightPerformanceMutableArray != nil{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        
        if journey != nil{
            for j in 0..<(journey?.count ?? 0){
                if let allFlights = journey?[j].leg.first?.flights{
                    for k in 0..<allFlights.count{
                        let storedTime = journey?[j].leg[0].flights[k].ontimePerformanceDataStoringTime ?? ""
                        
                        //                            if storedTime != nil {
                        let currTime = "\(hour):\(minutes):\(seconds)"
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        let formatedStoredTime = dateFormatter.date(from:storedTime)
                        let formatedCurrTime = dateFormatter.date(from:currTime)
                        
                        let calendarFormat = NSCalendar.current
                        guard let formattedStoredTime = formatedStoredTime, let formattedCurTime = formatedCurrTime, let next3MinutesTime = calendarFormat.date(byAdding: .minute, value: 3, to: formattedStoredTime) else { return }
                        
                        if formattedCurTime > next3MinutesTime{
                            journey?[j].leg[0].flights[k].ontimePerformance = nil
                            journey?[j].leg[0].flights[k].latePerformance = nil
                            journey?[j].leg[0].flights[k].cancelledPerformance = nil
                            journey?[j].leg[0].flights[k].observationCount = nil
                            journey?[j].leg[0].flights[k].averageDelay = nil
                            journey?[j].leg[0].flights[k].ontimePerformanceDataStoringTime = nil
                            
                        }
                        //                            }
                    }
                    //                    }
                    
                }
            }
        }
    }
    
    func checkTimeAndClearFlightBaggageResultCache(){
//        if appdelegate.flightBaggageMutableArray != nil{
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            for i in 0..<self.appdelegate.flightBaggageMutableArray.count{
                if i < appdelegate.flightBaggageMutableArray.count{
                    if let ass = self.appdelegate.flightBaggageMutableArray[i] as? JSONDictionary
                    {
                        let storedTime = ass["Time"] as? String ?? ""
                        
                        let currTime = "\(hour):\(minutes):\(seconds)"
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        let formatedStoredTime = dateFormatter.date(from:storedTime)
                        let formatedCurrTime = dateFormatter.date(from:currTime)
                        
                        let calendarFormat = NSCalendar.current
                        guard let formatedStoredTime1 = formatedStoredTime, let formatedCurrTime1 = formatedCurrTime,let next3MinutesTime = calendarFormat.date(byAdding: .minute, value: 3, to: formatedStoredTime1) else{return}
                        
                        if formatedCurrTime1 > next3MinutesTime{
                            self.appdelegate.flightBaggageMutableArray.removeObject(at: i)
                        }
                    }
                }
            }
//        }
    }
    
    ///For clear cache for international return and multicity.
       func checkTimeAndClearIntFlightPerformanceResultCache(journey: IntJourney?)-> IntJourney?{
//           if appdelegate.flightPerformanceMutableArray != nil{
               let date = Date()
               let calendar = Calendar.current
               let hour = calendar.component(.hour, from: date)
               let minutes = calendar.component(.minute, from: date)
               let seconds = calendar.component(.second, from: date)
               
               
               if var newJourney = journey{
                   
                   for j in 0..<newJourney.legsWithDetail.count{
                       let allFlights = newJourney.legsWithDetail[j].flightsWithDetails
                       for k in 0..<allFlights.count{
                           let storedTime = newJourney.legsWithDetail[j].flightsWithDetails[k].ontimePerformanceDataStoringTime ?? ""
                           
//                           if storedTime != nil{
                               let currTime = "\(hour):\(minutes):\(seconds)"
                               
                               let dateFormatter = DateFormatter()
                               dateFormatter.dateFormat = "HH:mm:ss"
                               let formatedStoredTime = dateFormatter.date(from:storedTime)
                               let formatedCurrTime = dateFormatter.date(from:currTime)
                               
                               let calendarFormat = NSCalendar.current
//                               let next3MinutesTime = calendarFormat.date(byAdding: .minute, value: 3, to: formatedStoredTime)
                            
//                            guard let formattedStoredTime = formatedStoredTime, let formattedCurTime = formatedCurrTime, let next3MinutesTime = calendarFormat.date(byAdding: .minute, value: 3, to: formattedStoredTime) else { return }

                            guard let formattedCurTime = formatedCurrTime, let formatedStoredTime1 = formatedStoredTime, let next3MinutesTime = calendarFormat.date(byAdding: .minute, value: 3, to: formatedStoredTime1) else{ return journey}
                            
                               if formattedCurTime > next3MinutesTime{
                                   newJourney.legsWithDetail[j].flightsWithDetails[k].ontimePerformance = nil
                                   newJourney.legsWithDetail[j].flightsWithDetails[k].latePerformance = nil
                                   newJourney.legsWithDetail[j].flightsWithDetails[k].cancelledPerformance = nil
                                   newJourney.legsWithDetail[j].flightsWithDetails[k].observationCount = nil
                                   newJourney.legsWithDetail[j].flightsWithDetails[k].averageDelay = nil
                                   newJourney.legsWithDetail[j].flightsWithDetails[k].ontimePerformanceDataStoringTime = nil
                                   
                               }
//                           }
                       }
                   }
                   return newJourney
               }
               
//           }
           return journey
       }

}

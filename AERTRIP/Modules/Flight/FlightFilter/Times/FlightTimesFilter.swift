//
//  FlightTimesFilter.swift
//  Aertrip
//
//  Created by  hrishikesh on 27/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation


struct  FlightLegTimeFilter {
    var leg : Leg
    var departureMinTime : Date
    var departureTimeMax : Date
    var userSelectedStartTime : Date
    var userSelectedEndTime : Date
    
    var arrivalStartTime : Date
    var arrivalEndTime : Date
    
    var userSelectedArrivalStartTime : Date
    var userSelectedArrivalEndTime : Date
    
    init ( leg : Leg , departureStartTime : Date , departureMaxTime : Date , arrivalStartTime: Date , arrivalEndTime: Date) {
        
        self.leg = leg
        self.departureMinTime = departureStartTime
        self.userSelectedStartTime = departureStartTime
        self.departureTimeMax = departureMaxTime
        self.userSelectedEndTime = departureMaxTime
        
        self.arrivalStartTime = arrivalStartTime
        self.arrivalEndTime = arrivalEndTime
        
        self.userSelectedArrivalStartTime = arrivalStartTime
        self.userSelectedArrivalEndTime = arrivalEndTime
        
    }
    
    func filterApplied() -> Bool {
        
        if userSelectedStartTime > departureMinTime {
            return true
        }
        if userSelectedEndTime < departureTimeMax {
            return true
        }
        if userSelectedArrivalStartTime > arrivalStartTime {
            return true
        }
        if userSelectedArrivalEndTime < arrivalEndTime {
            return true
        }
        
        return false
    }
    
    
        mutating func resetFilter() {
        
         self.userSelectedStartTime = self.departureMinTime
         self.userSelectedEndTime =  self.departureTimeMax         
         self.userSelectedArrivalStartTime = self.arrivalStartTime
         self.userSelectedArrivalEndTime = self.arrivalEndTime

    }
    
    
}

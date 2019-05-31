//
//  MyBookingFilterVM.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

enum BookingSortType {
    case travelDate
    case eventType
    case bookingDate
}

class MyBookingFilterVM {
    
    // shared instance
    static let shared = MyBookingFilterVM()
    
    
    // Booking sorting Type
    var bookingSortType: BookingSortType = .travelDate
    // Travel Date
    var travelFromDate: Date = Date()
    var travelToDate: Date = Date()
    
    // Booking Date
    var bookingFromDate: Date = Date()
    var bookingToDate: Date = Date()
    


    // let event Type filter 
    var eventType: [Int] = [1]
    
    
    
   
    
    
    private init() {
        
    }
    
    
    
}

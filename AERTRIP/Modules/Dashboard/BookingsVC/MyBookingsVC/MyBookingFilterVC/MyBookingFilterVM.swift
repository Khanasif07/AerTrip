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
    var travelFromDate: Date?
    var travelToDate: Date?
    
    // Booking Date
    var bookingFromDate: Date?
    var bookingToDate: Date?
    
    // let event Type filter
    var eventType: [Int] = [1,2,3]
    
    var totalResultCount: Int {
        return CoreDataManager.shared.fetchData(fromEntity: "BookingData", forAttribute: "bookingId", usingFunction: "count").count
    }
    var filteredUpcomingResultCount: Int = 0
    var filteredCompletedResultCount: Int = 0
    var filteredCanceledResultCount: Int = 0
    
    var filteredResultCount: Int {
        return filteredUpcomingResultCount + filteredCompletedResultCount + filteredCanceledResultCount
    }

    var searchText: String = ""
    
    private init() {
    }
    
    func setToDefault() {
        self.bookingSortType = .travelDate
        
        self.travelFromDate = nil
        self.travelToDate = nil
        
        self.bookingFromDate = nil
        self.bookingToDate = nil
        
        self.eventType = [1,2,3]
    }
}

extension MyBookingFilterVM: CustomStringConvertible {
    var description: String {
        var temp = ""
        temp += "bookingSortType \(bookingSortType)\n"
        temp += "travelFromDate \(travelFromDate?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? "-")\n"
        temp += "travelToDate \(travelToDate?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? "-")\n"
        temp += "bookingFromDate \(bookingFromDate?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? "-")\n"
        temp += "bookingToDate \(bookingToDate?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? "-")\n"
        temp += "eventType \(eventType)\n"
        
        return temp
    }
}

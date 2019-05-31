//
//  MyBookingsVM.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol MyBookingsVMDelegate: class {
    func willGetBookings()
    func getBookingsDetailSuccess()
    func getBookingDetailFail(error:ErrorCodes)
}

class MyBookingsVM {
    
    // MARK: - Variables
    var upComingBookingsData: [String] = ["1"]
    var completedBookingsData: [String] = ["2"]
    var cancelledBookingData: [String] = []
    
//    var upComingBookings: [BookingModel] = []
//    var completedBookings: [BookingModel] = []
    
    
    
    // MARK: - Booking Data
    
    // MARK: - Upcoming Bookings
    var upComingBookings: [BookingData] = []
    var completedBookings: [BookingData] = []
    var cancelledBookings: [BookingData] = []
    
    var bookings: [BookingModel] = []
    weak var delgate: MyBookingsVMDelegate?
    static let shared = MyBookingsVM()
//
//    func getFilteredData() {
//        self.upComingBookings = bookings.filter({  $0.bookingDetails?.eventStartDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isGreaterThan((Date())) ?? false})
//        self.completedBookings  = bookings.filter({  $0.bookingDetails?.eventStartDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isSmallerThan((Date())) ?? false})
//
//    }
//
    
    
    
    func getBookingData() {
        
        if let upcomingBookings = CoreDataManager.shared.fetchData("BookingData", predicate: "bookingTabType == '1'") as? [BookingData] {
               self.upComingBookings = upcomingBookings
        }
        
        if let completedBookings = CoreDataManager.shared.fetchData("BookingData", predicate: "bookingTabType == '2'") as? [BookingData] {
            self.completedBookings = completedBookings
        }
        
        if let cancelledBookings = CoreDataManager.shared.fetchData("BookingData", predicate: "bookingTabType == '3'") as? [BookingData] {
            self.cancelledBookings = cancelledBookings
        }
    }
    
    private init() {}
    
    func getBookings() {
        let params: JSONDictionary = [:]
        printDebug(params)
            delgate?.willGetBookings()
        APICaller.shared.getBookingList(params: params)  {  [weak self] (success, error, bookings) in
            guard let sSelf = self else { return }
            if success {
                // sSelf.bookings = bookings
                sSelf.getBookingData()
                
                sSelf.delgate?.getBookingsDetailSuccess()
                printDebug(bookings)
            } else {
                
            }
        }
    }
}

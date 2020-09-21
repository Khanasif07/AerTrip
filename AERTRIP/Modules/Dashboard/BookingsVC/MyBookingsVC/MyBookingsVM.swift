//
//  MyBookingsVM.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol MyBookingsVMDelegate: class {
    func willGetBookings(showProgress: Bool)
    func getBookingsDetailSuccess(showProgress: Bool)
    func getBookingDetailFail(error: ErrorCodes,showProgress: Bool)
}

class MyBookingsVM {
    // MARK: - Variables
    
    // MARK: - Booking Data
    
    // MARK: - Upcoming Bookings
    
    var allTabTypes: [Int16] = [] // fetching when data is getting inserted in
    
    weak var delgate: MyBookingsVMDelegate?
    static let shared = MyBookingsVM()
    var isFetchingBooking = false
    //
    //    func getFilteredData() {
    //        self.upComingBookings = bookings.filter({  $0.bookingDetails?.eventStartDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isGreaterThan((Date())) ?? false})
    //        self.completedBookings  = bookings.filter({  $0.bookingDetails?.eventStartDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isSmallerThan((Date())) ?? false})
    //
    //    }
    //
    
    private init() {}
    
    func getBookings(showProgress: Bool) {
        guard !isFetchingBooking else {return}
        isFetchingBooking = true
        let params: JSONDictionary = [:]
        printDebug(params)
        //        if shouldCallWillDelegate {
        //            delgate?.willGetBookings()
        //        }
        delgate?.willGetBookings(showProgress: showProgress)
        APICaller.shared.getBookingList(params: params) { [weak self] success, error in
            DispatchQueue.mainAsync { [weak self] in
                guard let sSelf = self else { return }
                if success {
                    sSelf.delgate?.getBookingsDetailSuccess(showProgress: showProgress)
                } else {
                    sSelf.delgate?.getBookingDetailFail(error: error, showProgress: showProgress)
                }
                sSelf.isFetchingBooking = false
            }
        }
    }
}

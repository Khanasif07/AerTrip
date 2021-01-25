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
    func getDeepLinkDetailsSuccess(_ bookingDetailModel: BookingDetailModel)
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
    var deepLinkBookingId  = ""
    var bookingListAPIResponse :(Bool, ErrorCodes)?
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
                guard let self = self else { return }
                if self.deepLinkBookingId.isEmpty{
                    if success {
                        self.delgate?.getBookingsDetailSuccess(showProgress: showProgress)
                    } else {
                        self.delgate?.getBookingDetailFail(error: error, showProgress: showProgress)
                    }
                    self.isFetchingBooking = false
                }else{
                    self.bookingListAPIResponse = (success, error)
                }
            }
        }
    }
    
    func getBookingDetails(showProgress: Bool){
        let params: JSONDictionary = ["booking_id": self.deepLinkBookingId]

        APICaller.shared.getBookingDetail(params: params) { [weak self] success, errors, bookingDetail in
            guard let self = self else { return }
            self.deepLinkBookingId = ""
            if success , let bookingDetails = bookingDetail{
                self.delgate?.getDeepLinkDetailsSuccess(bookingDetails)
                guard let bookingResponse = self.bookingListAPIResponse else {return}
                if (bookingResponse.0){
                    self.delgate?.getBookingsDetailSuccess(showProgress: showProgress)
                }else{
                    self.delgate?.getBookingDetailFail(error: bookingResponse.1, showProgress: showProgress)
                }
            } else {
                guard let bookingResponse = self.bookingListAPIResponse else {return}
                if (bookingResponse.0){
                    self.delgate?.getBookingsDetailSuccess(showProgress: showProgress)
                }else{
                    self.delgate?.getBookingDetailFail(error: bookingResponse.1, showProgress: showProgress)
                }
            }
        }
    }
    
    
}

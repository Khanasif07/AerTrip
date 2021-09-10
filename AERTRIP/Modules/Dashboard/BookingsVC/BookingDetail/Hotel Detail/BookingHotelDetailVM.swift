//
//  BookingHotelDetailVM.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingHotelDetailVMDelgate: class {
    func getHotelDetailsSuccess()
    func getHotelDetailsFail()
}


class BookingHotelDetailVM {
    
    var bookingDetail: BookingDetailModel?
    var hotelTitle: String = ""
    var bookingId: String = ""
    var hotelName: String = ""
    var taRating: Double = 0.0
    var hotelStarRating: Double = 0.0
    
   // var hotelData: HotelDetails = HotelDetails()
    
    weak var delegate : BookingHotelDetailVMDelgate?
    
    //MARK:- //commenting this  whole flow as  there will be no API. Data will come from previous screen
    
//    func getHotelDetail() {
//
//        var params = JSONDictionary()
//        params["popular_destination"] = 1
//
//        APICaller.shared.getHotelInfo(params: params) { [weak self] (success, error, hotel) in
//
//            guard let sSelf = self else {return}
//
//            if success {
//                printDebug("hotel result is\(hotel)")
//                sSelf.hotelData = hotel ?? HotelDetails()
//            }
//            else {
//                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
//            }
//        }
//    }
    
    func getBookingDetail() {
        let params: JSONDictionary = ["booking_id": self.bookingId]
        
        //delegate?.willGetBookingDetail()
        APICaller.shared.getBookingDetail(params: params) { [weak self] success, errors, bookingDetail in
            guard let sSelf = self else { return }
            if success {
                sSelf.bookingDetail = bookingDetail
                sSelf.delegate?.getHotelDetailsSuccess()
            } else {
                sSelf.delegate?.getHotelDetailsFail()
                printDebug(errors)
            }
        }
    }
}

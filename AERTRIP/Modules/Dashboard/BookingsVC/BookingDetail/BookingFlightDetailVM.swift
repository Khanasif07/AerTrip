//
//  BookingDetailVM.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingDetailVMDelegate: class {
    func legDetailsSuccess() //temp methods
    
    func willGetBookingFees()
    func getBookingFeesSuccess()
    func getBookingFeesFail()
}

class BookingDetailVM {
    
    let tempModel = BookingProductDetailVM()
    
    weak var delegate: BookingDetailVMDelegate?
    
    var bookingId: String = ""
    var legDetails: [Leg] = []
    var bookingFee: BookingFeeDetail?
    var tripCitiesStr: NSAttributedString?
    
    init() {
        tempModel.delegate = self
        delay(seconds: 0.3) {
            self.tempModel.bookingId = self.bookingId
            self.tempModel.getBookingDetail()
        }
    }
    
    func getBookingFees() {

        let params: JSONDictionary = ["booking_id": bookingId, "ref_id": self.legDetails.first?.legId ?? ""]
        delegate?.willGetBookingFees()
        APICaller.shared.getBookingFees(params: params) { [weak self] success, errors, bookingFee in
            guard let sSelf = self else { return }
            if success {
                sSelf.bookingFee = bookingFee
                sSelf.delegate?.getBookingFeesSuccess()
            } else {
                sSelf.delegate?.getBookingFeesFail()
                printDebug(errors)
            }
        }
    }
}

extension BookingDetailVM: BookingProductDetailVMDelegate {
    func willGetBookingDetail() {
        
    }
    
    func getBookingDetailSucces() {
        self.legDetails = self.tempModel.bookingDetail?.bookingDetail?.leg ?? []
        self.tripCitiesStr = self.tempModel.bookingDetail?.tripCitiesStr
        self.delegate?.legDetailsSuccess()
    }
    
    func getBookingDetailFaiure() {
        
    }
}

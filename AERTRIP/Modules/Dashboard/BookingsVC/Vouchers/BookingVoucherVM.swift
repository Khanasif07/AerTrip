//
//  BookingVoucherVM.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingVoucherVMDelegate: class {
    func getAddonPaymentItinerarySuccess()
    func getAddonPaymentItineraryFail()
    
    func getBookingOutstandingPaymentSuccess()
    func getBookingOutstandingPaymentFail()
}

class BookingVoucherVM {
    var receipt: Receipt?
//    var caseId: String = ""
    var bookingId: String = ""

    weak var delegate: BookingVoucherVMDelegate? = nil
    private(set) var itineraryData: DepositItinerary?
    
//    func getAddonPaymentItinerary() {
//        APICaller.shared.addonPaymentAPI(params: ["case_id": caseId]) { [weak self](success, errors, itiner) in
//            if success {
//                self?.itineraryData = itiner
//                self?.delegate?.getAddonPaymentItinerarySuccess()
//            }
//            else {
//                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
//                self?.delegate?.getAddonPaymentItineraryFail()
//            }
//        }
//    }
    
    func getBookingOutstandingPayment() {
        APICaller.shared.bookingOutstandingPaymentAPI(params: ["booking_id": bookingId]) { [weak self](success, errors, itiner) in
            if success {
                self?.itineraryData = itiner
                self?.delegate?.getBookingOutstandingPaymentSuccess()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
                self?.delegate?.getBookingOutstandingPaymentFail()
            }
        }
    }
}


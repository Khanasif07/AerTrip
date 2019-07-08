//
//  BookingDetailVM.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingDetailVMDelegate: class {
    
    func willGetBookingFees()
    func getBookingFeesSuccess()
    func getBookingFeesFail()
}

class BookingDetailVM {
    
    weak var delegate: BookingDetailVMDelegate?
    
    var bookingDetail: BookingDetailModel?
    var legDetails: [Leg] {
        return self.bookingDetail?.bookingDetail?.leg ?? []
    }
    var bookingId: String {
        return self.bookingDetail?.id ?? ""
    }
    
    var bookingFee: BookingFeeDetail?
    
    let fareInfoNotes: [String] = ["Some fares may be non-refundable and non-amendable.",
        "Cancellation / Rescheduling Charges are indicative and can change without prior notice. Aertrip does not guarantee or warrant this information.",
        "They may be subject to currency fluctuations.",
        "They need to be reconfirmed prior to any amendments or cancellation.",
        "Total Rescheduling Charges also include Fare Difference (if applicable).",
        "Airlines stop accepting cancellation/rescheduling requests 3 - 75 hours before departure of the flight, depending on the airline.",
        "For confirming cancellation/change fee, please call us at our customer care."]
    
    func getBookingFees() {

        let params: JSONDictionary = ["booking_id": bookingId, "ref_id": legDetails.first?.legId ?? ""]
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

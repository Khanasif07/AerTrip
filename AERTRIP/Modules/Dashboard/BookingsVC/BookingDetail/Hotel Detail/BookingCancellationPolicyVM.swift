//
//  BookingCancellationPolicyVM.swift
//  AERTRIP
//
//  Created by apple on 15/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

enum VCUsingFor {
    case bookingPolicy
    case cancellationPolicy
}

protocol BookingCancellationPolicyVMDelegate: class {
    func willGetBookingPolicy()
    func getBookingPolicySuccess()
    func getBookingPolicyFail()
}

class BookingCancellationPolicyVM {

  
    var vcUsingType: VCUsingFor = .bookingPolicy
    var bookingDetail: BookingDetailModel?
    var bookingPolicies: String = ""
    
    weak var delegate: BookingCancellationPolicyVMDelegate?
    
    func getBookingPolicy() {
        guard let booking = bookingDetail else {
            return
        }
        
        self.delegate?.willGetBookingPolicy()
        let param: JSONDictionary = ["booking_id": booking.id, "hotel_id" : booking.bookingDetail?.hotelId ?? ""]
        APICaller.shared.getFareRulesAPI(params: param, loader: false) { [weak self](success, errors, rules, rute) in
            
            guard let sSelf = self else {return}
            
            if success {
                sSelf.bookingPolicies = rules.isEmpty ? "Information not available" : rules
                sSelf.delegate?.getBookingPolicySuccess()
            }
            else {
                sSelf.delegate?.getBookingPolicyFail()
            }
        }
    }
    
    /***    Booking Policy Data         **/
    // Special Checking instruction - will Come from API
    let speicalCheckinInstructiion = ["24-hour airport shuttle service is available on request.","Contact the property in advance to make arrangements.","Taxes are subject to change based on Goods and Services Tax (GST) implementation","For more details, please contact the property using the information on the reservation confirmation received after booking."]
    
    let checinInstruction = ["Extra-person charges may apply and vary depending on property policy.","Government-issued photo identification and a credit card or cash deposit are required at check-in for incidental charges."," Special requests are subject to availability upon check-in and may incur additional charges."," Special requests cannot be guaranteed. The name on the credit card used at check-in to pay for incidentals must be the primary name on the guestroom reservation.","  Onsite parties or group events are strictly prohibited."," Please note that cultural norms and guest policies may differ by country and by property.","The policies listed are provided by the property."]
    
    let bookingNote = ["If holder is not one of the paxes, one of the adult paxes will be considered as holder"]
    
    
}

//
//  BookingFareInfoDetailVM.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingFareInfoDetailVMDelegate: class {
    func willGetFareRules()
    func getFareRulesSuccess(fareRules: String, ruteString: String)
    func getFareRulesFail()
}

class BookingFareInfoDetailVM {
    
    //used in case of multi legs
    var legDetails: Leg?
    var bookingFee: BookingFeeDetail?
    //used in case of multi legs
    
    var bookingId: String = ""
    
    weak var delegate: BookingFareInfoDetailVMDelegate?
    
    func getFareRules() {
        let param = ["booking_id": bookingId, "leg_id": legDetails?.legId ?? ""]
        
        self.delegate?.willGetFareRules()
        APICaller.shared.getFareRulesAPI(params: param) { (success, errors, fareRules, ruteString) in
            if success {
                self.delegate?.getFareRulesSuccess(fareRules: fareRules, ruteString: ruteString)
            }
            else {
                self.delegate?.getFareRulesFail()
            }
        }
    }
}

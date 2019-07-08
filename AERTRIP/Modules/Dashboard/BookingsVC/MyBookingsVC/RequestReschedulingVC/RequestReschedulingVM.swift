//
//  RequestReschedulingVM.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RequestReschedulingVMDelegate: class {
    func willMakeRequestForRescheduling()
    func makeRequestForReschedulingSuccess()
    func makeRequestForReschedulingFail()
}

class RequestReschedulingVM {
    
    var legsWithSelection: [Leg] = []
    
    var totRefund: Double {
        return legsWithSelection.reduce(0) { $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.netRefundForReschedule })) }
    }
    
    weak var delegate: RequestReschedulingVMDelegate?
    
    private func getParamForRescheduling() -> JSONDictionary {
        
        //        6930[date]: 2019-07-06
        //        6931[date]: 2019-07-09
        //
        //        6930[preferred_flight]: erer
        //        6931[preferred_flight]: dfadfa
        //
        //        6930[pax_id][]: 18666
        //        6931[pax_id][]: 18668
        //        6931[pax_id][]: 18669
        //
        //        booking_id: 10519
        
        var params: JSONDictionary = JSONDictionary()
        for leg in self.legsWithSelection {
            
            //set dates
            if let rDate = leg.rescheduledDate {
                params["\(leg.legId)[date]"] = rDate.toString(dateFormat: "yyyy-MM-dd")
            }
            else {
                AppToast.default.showToastMessage(message: "Please select all rescheduling dates.")
                break
            }
            
            //set preferred_flight if any
            if !leg.prefredFlightNo.isEmpty {
                params["\(leg.legId)[preferred_flight]"] = leg.prefredFlightNo
            }
            
            //set selected pax_id
            for pax in leg.selectedPaxs {
                params["\(leg.legId)[pax_id][]"] = pax.paxId
            }
            
            params["booking_id"] = leg.bookingId
        }
        
        return params
    }
    
    func makeRequestForRescheduling() {
        
        let params = self.getParamForRescheduling()
        
        self.delegate?.willMakeRequestForRescheduling()
        APICaller.shared.rescheduleRequestAPI(params: params) { (success, error) in
            if success {
                self.delegate?.makeRequestForReschedulingSuccess()
            }
            else {
                self.delegate?.makeRequestForReschedulingFail()
            }
        }
    }
}

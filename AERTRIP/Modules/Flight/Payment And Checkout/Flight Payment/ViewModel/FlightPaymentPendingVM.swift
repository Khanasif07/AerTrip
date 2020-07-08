//
//  FlightPaymentPendingVM.swift
//  AERTRIP
//
//  Created by Apple  on 29.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


protocol FlightPaymentPendingVMDelegate:NSObjectProtocol{
    func willRequestForRefund()
    func refundRequestResponse(_ success: Bool, error:ErrorCodes)
    
}

class FlightPaymentPendingVM{
    
    var itId = ""
    var product:ProductType = .flight
    var itinerary = FlightItinerary()
    //flightItinerary
    weak var delegate: FlightPaymentPendingVMDelegate?
    
    
    func requestForRefund(){
        self.delegate?.willRequestForRefund()
        let param = [APIKeys.it_id.rawValue: itId]
        APICaller.shared.refundAPIForPendingPayment(params: param) {[weak self] (success, error, msg) in
            guard let self = self else {return}
            self.delegate?.refundRequestResponse(success, error:error)
            
        }
    }
    
}

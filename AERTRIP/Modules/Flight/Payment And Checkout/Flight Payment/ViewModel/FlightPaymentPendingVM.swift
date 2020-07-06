//
//  FlightPaymentPendingVM.swift
//  AERTRIP
//
//  Created by Apple  on 29.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class FlightPaymentPendingVM{
    
    var itId = ""
    var product:ProductType = .flight
    var itinerary = FlightItinerary()
    //flightItinerary
    
    func getItineraryDetails(){
        
        let param = [APIKeys.it_id.rawValue: itId]
        
        APICaller.shared.getItinerayDataForPendingPayment(params: param) {[weak self] (success, error, data) in
            guard let self = self else {return}
            if success, let itinerary = data {
                self.itinerary = itinerary
            }else{
                
            }
        }
        
    }
    
}

//
//  FrequentFlyerData.swift
//  AERTRIP
//
//  Created by apple on 02/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct FrequentFlyerData {
    var passenger: Pax?
    var flights: [BookingFlightDetail] = []
    
    
    init() {
       self.init(passenger: Pax(), flights: [])
    }
    
    init(passenger: Pax, flights: [BookingFlightDetail]) {
        self.passenger = passenger
        self.flights = flights
    }

}

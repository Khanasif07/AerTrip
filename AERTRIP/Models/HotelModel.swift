//
//  HotelModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct HotelsModel {
    
    var hotelMinStar : Double
    var hotelMaxStar : Double
    
    
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.hotelMinStar  = json["hotel_min_star"].doubleValue
        self.hotelMaxStar  = json["hotel_max_star"].doubleValue
    }
}

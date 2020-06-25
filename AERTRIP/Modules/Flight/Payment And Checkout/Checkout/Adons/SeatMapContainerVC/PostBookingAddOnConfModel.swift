//
//  PostBookingAddOnConfModel.swift
//  AERTRIP
//
//  Created by Rishabh on 25/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct PostBookingAddOnConfModel {
    
    let itinerary: ItineraryModel
    
    init(_ json: JSON) {
        itinerary = ItineraryModel(json["data"]["itinerary"])
    }
    
    struct ItineraryModel {
        let id: String
        
        init(_ json: JSON) {
            id = json["id"].stringValue
        }
    }
}

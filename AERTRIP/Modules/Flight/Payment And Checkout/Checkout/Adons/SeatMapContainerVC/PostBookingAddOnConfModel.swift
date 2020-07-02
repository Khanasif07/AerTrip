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
//        let netAmount: Int
//        let walletBalance: Int
//        let details: ItineraryDetailsModel
        let id: String
//        let bankMaster: [Int: String]
//        let userPoints: Int
//        let pointsBalance: Int
//        let paymentModes: PaymentModesModel
//        let currency: String
        
        init(_ json: JSON) {
            id = json["id"].stringValue
        }
    }
    
//    struct ItineraryDetailsModel {
//        let leg: [LegModel]
//        let grandTotal: Int
//        let addOns: AddOnsModel
//        let addOnsTotal: Int
//        let addOnsSum: AddOnsSumModel
//    }
//
//    struct PaymentModesModel {
//
//    }
//
//    struct LegModel {
//        let flights: [FlightModel]
//        let flightIds: [String]
//        let legTotal: Int
//    }
//
//    struct AddOnsModel {
//
//    }
//
//    struct AddOnsSumModel {
//
//    }
//
//    struct FlightModel {
//
//    }
}

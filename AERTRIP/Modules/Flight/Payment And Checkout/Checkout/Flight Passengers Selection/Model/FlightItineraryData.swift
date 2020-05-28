//
//  FlightItineraryData.swift
//  AERTRIP
//
//  Created by Apple  on 28.05.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct FlightItineraryData{
    
//    var itinerary:FlightItineraryData
    
}

struct FlightItinerary {
    var id : String
    var sid : String
    var isInternational : Bool
    var combo : Bool
    var displaySeatmapLink : Bool
    var freeMealSeat : Bool
    var freeMeal : Bool
    var iic : Bool
    var gstRequired : Bool
    var searchParams:FlightSearchParam
    var priceChange : Int
    var minAmount : Int
    var netAmount : Int
    var isRefundable : Bool
    var walletBalance : Int
    var userPoints : Int
//    var traveller_details:
    
    init(_ json:JSON = JSON()){
        id = json["id"].stringValue
        sid = json["sid"].stringValue
        isInternational  = json["is_international"].boolValue
        combo = json["combo"].boolValue
        displaySeatmapLink  = json["display_seatmap_link"].boolValue
        freeMealSeat = json["free_meal_seat"].boolValue
        freeMeal = json["free_meal"].boolValue
        iic = json["iic"].boolValue
        gstRequired = json["gst_required"].boolValue
        searchParams = FlightSearchParam(json["search_params"])
        priceChange = json["price_change"].intValue
        minAmount = json["min_amount"].intValue
        netAmount = json["net_amount"].intValue
        isRefundable = json["is_refundable"].boolValue
        walletBalance = json["wallet_balance"].intValue
        userPoints = json["user_points"].intValue
        
    }
    
    
}


struct FlightSearchParam{
    var adult : String
    var cabinclass : String
    var child : String
    var depart : String
    var destination : String
    var infant : String
    var origin : String
    var returnDate : String
    var tripType : String
    var sessionId : String
    
    
    init(_ json:JSON = JSON()){
        adult = json["sid"].stringValue
        cabinclass = json["cabinclass"].stringValue
        child = json["child"].stringValue
        depart = json["depart"].stringValue
        destination = json["destination"].stringValue
        infant = json["infant"].stringValue
        origin = json["origin"].stringValue
        returnDate = json["return"].stringValue
        tripType = json["trip_type"].stringValue
        sessionId = json["session_id"].stringValue
        
    }
    
}

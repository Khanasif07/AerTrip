//
//  FlightItineraryData.swift
//  AERTRIP
//
//  Created by Apple  on 28.05.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


struct FlightItineraryData{
    var itinerary:FlightItinerary
    var searchParam:FlightSearchParam?
    var changeResults:[String:ChangeResult]?
    //Coupon Appied
    var isCouponAppied:Bool?
    var couponCode:String?
    var discountsBreakup:DiscountBreakUp?
    init(_ json:JSON = JSON()){
        itinerary = FlightItinerary(json["itinerary"])
        changeResults = Dictionary(uniqueKeysWithValues: json["change_results"].map{ ($0.0, ChangeResult($0.1)) })
        isCouponAppied = json["is_coupon_applied"].bool
        couponCode = json["coupon_code"].string
        if let dict = json["discounts_breakup"].dictionaryObject{
          discountsBreakup = DiscountBreakUp(json: dict)
        }
        if json["search_params"].dictionaryObject != nil{
            searchParam = FlightSearchParam(json["search_params"])
        }
    }
}

struct FlightItinerary {
    var id : String
    var sid : String
    var isInternational : Bool
    var combo : Bool
    var displaySeatmapLink : Bool
    var freeMealSeat = false//: Bool
    var freeMeal = false//: Bool
    var freeSeats = false
    var iic : Bool
    var gstRequired : Bool
    var searchParams:FlightSearchParam
    var priceChange : Int
    var minAmount : Int
    var netAmount : Int
    var isRefundable : Bool
    var walletBalance : Int
    var userPoints : Int
    var details:IntJourney
    var travellerDetails:TravellerDetails
    var travellerMaster:[TravellerModel]
    var paymentModes:PaymentMode
    var couponCode: String
    var pointsBalance: Int
    var partPaymentProcessingFee:Int
    //part_payment_due_date: ""
    //seatmap: ""
    //selected_apf: {leg: ""}
   

    
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
        details = IntJourney(jsonData: json["details"])
        travellerDetails = TravellerDetails(json["traveller_details"])
        travellerMaster = json["traveller_master"]["aertrip"].arrayValue.map{TravellerModel(json: $0)}
        paymentModes = PaymentMode(json: json["payment_modes"])
        couponCode = json["coupon_code"].stringValue
        pointsBalance = json["points_balance"].intValue
        partPaymentProcessingFee = json["part_payment_processing_fee"].intValue
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
    var paxTypes:String
    //For Multicity
    var originArr : [String]?
    var paxTypesArr: [String]?
    var dipartArr : [String]?
    var destinationArr : [String]?
    
    
    init(_ json:JSON = JSON()){
        adult = json["adult"].stringValue
        cabinclass = json["cabinclass"].stringValue
        child = json["child"].stringValue
        depart = json["depart"].stringValue
        destination = json["destination"].stringValue
        infant = json["infant"].stringValue
        origin = json["origin"].stringValue
        returnDate = json["return"].stringValue
        tripType = json["trip_type"].stringValue
        paxTypes = json["pax_types"].stringValue
        sessionId = json["session_id"].stringValue
        originArr = json["origin"].arrayObject as? [String]
        dipartArr = json["depart"].arrayObject as? [String]
        destinationArr = json["destination"].arrayObject as? [String]
        paxTypesArr = json["pax_types"].arrayObject as? [String]
    }
    
}

struct TravellerDetails{
    var mobile: String
    var isd: String
    var gstDetails:FlightGST?
    init(_ json:JSON = JSON()){
        mobile = json["mobile"].stringValue
        isd = json["isd"].stringValue
        if json["gst_details"].dictionary != nil{
            gstDetails = FlightGST(json["gst_details"])
        }
    }
}

struct FlightGST{
    
    var gstNumber:String
    var gstCompanyName:String
    var gstAddressLine1:String
    var gstAddressLine2:String
    var gstCity:String
    var gstStateName:String
    var gstPostalCode:String
    var gst:String
    
    init(_ json:JSON = JSON()){
        gstNumber = json["gst_number"].stringValue
        gstCompanyName = json["gst_company_name"].stringValue
        gstAddressLine1 = json["gst_address_line1"].stringValue
        gstAddressLine2 = json["gst_address_line2"].stringValue
        gstCity = json["gst_city"].stringValue
        gstStateName = json["gst_state_name"].stringValue
        gstPostalCode = json["gst_postal_code"].stringValue
        gst = json["gst_postal_code"].stringValue
    }
}

struct ChangeResult{
    var farepr: Int
    var fare:IntTaxes
    init(_ json:JSON = JSON()){
        farepr = json["farepr"].intValue
        fare = IntTaxes(json["fare"])
    }
}

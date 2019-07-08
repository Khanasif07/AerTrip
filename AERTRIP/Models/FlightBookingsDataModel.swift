//
//  FlightBookingsDataModel.swift
//  
//
//  Created by Admin on 29/05/19.
//

import Foundation

struct FlightBookingsDataModel {
    
    var id: String = ""
    var booking_number: String = ""
    var booking_date: String = ""
    var communication_number: String = ""
    var depart: String = ""
    var billing_info: BillingInfo?
    var address: TravellerAddress?
    var category: String = ""
    var trip_type: String = ""
    var special_fares: String = ""
    var bdetails: BillDetails?
    var itinerary_id: String = ""
    var cases: [String] = []
    var receipt: Receipt?
    var total_amount_paid: Double = 0
    var vcode: String = ""
    var bstatus: String = ""
    var documents: [TravellerDocuments] = []
    var addon_request_allowed: Bool = false
    var cancellation_request_allowed: Bool = false
    var reschedule_request_allowed: Bool = false
    var special_request_allowed: Bool = false
    var user: TravellerUser?
}

struct BillingInfo {
    var email: String = ""
    var communication_number: String = ""
    var billing_name: String = ""
    var gst: String = ""
}

struct TravellerAddress {
    var address_line1: String = ""
    var address_line2: String = ""
    var city: String = ""
    var state: String = ""
    var postal_code: String = ""
    var country: String = ""
    var product: String = ""

}

struct BillDetails {
    
}



struct TravellerDocuments {
    
}

struct TravellerUser {
    var pax_id: Int = 0
    var email: String = ""
    var billing_name: String = ""
    var mobile: String = ""
    var credit_type: String = ""
    var isd: String = ""
    var points: Int = 0
    var account_data: TravellerAccountData?
    var profile_name: String = ""
    var profile_img: String = ""
}

struct TravellerAccountData {
    
}

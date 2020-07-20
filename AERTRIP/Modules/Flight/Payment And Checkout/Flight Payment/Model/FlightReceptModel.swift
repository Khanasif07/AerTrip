//
//  FlightReceptModel.swift
//  AERTRIP
//
//  Created by Apple  on 15.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

// MARK: - DataClass
struct FlightReceptModelData {
    var receipt: FlightRecept
    init(_ json:JSON = JSON()){
        receipt = FlightRecept(json["receipt"])
    }
}

// MARK: - Receipt
struct FlightRecept {
    var id, sid: String
    var details: IntJourney
    var bookingStatus: BookingStatus
    var partPayment: PartPayment
    var travellerDetails: FlightTravellerDetails
//    var selectedApf, seatmapRequest, addons: [JSONAny]
    var city, country: [String]
    var hotelLinkParam: [HotelLinkParam]
    var bookingNumber: String
    var paymentDetails: PaymentDetails
    var tripDetails: TripDetails
    var tk, currency: String
    var whatNext:[WhatNext]

    init(_ json:JSON = JSON()) {
        id = json["id"].stringValue
        sid = json["sid"].stringValue
        details = IntJourney(jsonData: json["details"])
        bookingStatus = BookingStatus(json["booking_status"])
        partPayment = PartPayment(json["part_payment"])
        travellerDetails = FlightTravellerDetails(json["traveller_details"])
//        selectedApf = "selected_apf"
//        seatmapRequest = "seatmap_request"
//        addons,
        city = json["city"].arrayValue.map{$0.stringValue}
        country = json["country"].arrayValue.map{$0.stringValue}
        hotelLinkParam = json["hotel_link_param"].arrayValue.map{HotelLinkParam($0)}
        bookingNumber = json["booking_number"].stringValue
        paymentDetails = PaymentDetails(json["payment_details"])
        tripDetails = TripDetails(json: json["trip_details"].dictionaryValue)
        tk = json["tk"].stringValue
        currency = json["currency"].stringValue
        whatNext =  json["whatsNext"].arrayValue.map{WhatNext($0)}
    }
}

// MARK: - BookingStatus
struct BookingStatus {
    var bookingId: String
    var status: String
    init(_ json: JSON = JSON()){
        bookingId = json.dictionaryValue.keys.first ?? ""
        status = json.dictionaryValue.values.first?.stringValue ?? ""
    }
    
}


// MARK: - HotelLinkParam
struct HotelLinkParam {
    var destID, destType, destName, checkin: String
    var checkout, city, country, star: String

    init(_ json: JSON = JSON()){
        destID = json["dest_id"].stringValue
        destType = json["dest_type"].stringValue
        destName = json["dest_name"].stringValue
        checkin = json["checkin"].stringValue
        checkout = json["checkout"].stringValue
        city = json["city"].stringValue
        country = json["country"].stringValue
        star = json["tar "].stringValue
    }
}


struct  WhatNext {
    var star, destType, checkout, prodcut: String
    var destID, city, country: String
    var rooms: RoomPassengerData
    var checkin, destName: String
    var origin, totalLegs, adult, infant, depart, destination,tripType, cabinclass,child : String
    var productType:ProductType
    
    init(_ json:JSON = JSON()){
        star = json["star"].stringValue
        destType = json["dest_type"].stringValue
        checkout = json["checkout"].stringValue
        prodcut = json["product"].stringValue
        destID = json["dest_id"].stringValue
        city = json["city"].stringValue
        country = json["country"].stringValue
        rooms = RoomPassengerData(json["rooms"])
        checkin = json["checkin"].stringValue
        destName = json["destName"].stringValue
        origin = json["origin"].stringValue
        totalLegs = json["totalLegs"].stringValue
        adult = json["adult"].stringValue
        infant = json["infant"].stringValue
        depart = json["depart"].stringValue
        destination = json["destination"].stringValue
        tripType = json["trip_type"].stringValue
        cabinclass = json["cabinclass"].stringValue
        child = json["child"].stringValue
        productType = ProductType.getTypeFrom(self.prodcut)
    }

}

struct RoomPassengerData{
    
    var room = [Rooms]()
    var city = String()
    
    init(_ json:JSON = JSON()){
        room = json["rooms"].arrayValue.map{Rooms($0)}
        city = json["city"].stringValue
    }
}

struct Rooms {
    var adult:Int
    var child:Int
    init(_ json:JSON = JSON()){
        adult = json["adult"].intValue
        child = json["child"].intValue
    }
}

// MARK: - PartPayment
struct PartPayment {
    var date: String
    var amountPaid, amountRemaining: Int

    init(_ json:JSON = JSON()){
        date = json["date"].stringValue
        amountPaid = json["amount_paid"].intValue
        amountRemaining = json["amount_remaining"].intValue
    }
}


// MARK: - TravellerDetails
struct FlightTravellerDetails {
    var t: [T]
    var mobile, isd: String
    
    init(_ json: JSON = JSON()){
        mobile = json["mobile"].stringValue
        isd = json["isd"].stringValue
        t = json["t"].arrayValue.map{T($0)}
    }
    
}

// MARK: - T
struct T {
    var paxID, salutation, paxType, firstName: String
    var lastName, dob, age, passportExpiryDate: String
    var passportCountry, passportNumber, addedWhileBooking: String
    var email: [Email]
    var profileImg: String
    var ticketDetails: [TicketDetail]
    
    init(_ json: JSON = JSON()) {
        paxID = json["pax_id"].stringValue
        salutation = json["salutation"].stringValue
        paxType = json["pax_type"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        dob = json["dob"].stringValue
        age = json["age"].stringValue
        passportExpiryDate = json["passport_expiry_date"].stringValue
        passportCountry = json["passport_country"].stringValue
        passportNumber = json["passport_number"].stringValue
        addedWhileBooking = json["added_while_booking"].stringValue
        email = json["email"].arrayValue.map{Email(json: $0)}
        profileImg = json["profile_img"].stringValue
        ticketDetails = json["ticket_details"].dictionaryValue.map { TicketDetail($0.0 ,$0.1)}
    }
}


// MARK: - TicketDetail
struct TicketDetail {
    var ticketId:String
    var pnr, ticketNo: String

    init( _ key:String, _ json:JSON = JSON()) {
        ticketId = key
        pnr = json["pnr"].stringValue
        ticketNo = json["ticket_no"].stringValue
    }
}

struct AvailableSeatMap{
    
    var bookingId:String
    var name:String
    var isSelectedForall:Bool = false
    
}


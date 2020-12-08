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
    var id, sid, search_url: String
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
        search_url = json["search_url"].stringValue
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
        tripDetails = TripDetails(json["trip_details"])
        tk = json["tk"].stringValue
        currency = json["currency"].stringValue
        whatNext =  json["whatsNext"].arrayValue.map{WhatNext($0, isFor: "flight")}
        whatNext = whatNext.filter({ whtNxt -> Bool in
            if whtNxt.product == ""{
                return false
            }else if (whtNxt.productType == .flight) && (whtNxt.origin == "" || whtNxt.destination == ""){
                return false
            }else{
                return true
            }
        })//filter{$0.product != ""}
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
    var star, destType, checkout, product: String
    var destID, city, country: String
    var rooms: [RoomPassengerData]
    var checkin, destName: String
    var origin, totalLegs, adult, infant, depart, destination,tripType, cabinclass,child : String
    var returnDate: String
    var productType:ProductType
    var departCity:String
    var arrivalCity:String
    var settingFor: String
    var arrivalAirports = ""
    var departAiports = ""
    var arrivalCountryCode = ""
    var departureCountryCode = ""
    
    //Array for multicity flight result
    var originArr:[String]?
    var destinationArr:[String]?
    var departArr:[String]?
    var departCityArr:[String]?
    var arrivalCityArr:[String]?
    var arrivalAirportArr:[String]?
    var departAiportArr:[String]?
    var arrivalCountryCodeArr:[String]?
    var departureCountryCodeArr:[String]?
    
    var whatNextStringValue:String{
        
        if self.product.lowercased() == "hotel"{
            return "Book your hotel in\n\(self.city) & get the best deals!"
        }else if self.product.lowercased() == "flight"{
            return "Book your return flight for\n\(self.origin) to \(self.destination)"
        }else if self.product.lowercased() == "booking"{
            if self.settingFor == "hotel"{
                return "View or modify your booking."
            }else{
                return "View or modify your booking by adding add-ons & preferences"
            }
        }
        
        return ""
    }
    
    init(_ json:JSON = JSON(), isFor:String){
        star = json["star"].stringValue
        destType = json["dest_type"].stringValue
        checkout = json["checkout"].stringValue
        product = json["product"].stringValue
        destID = json["dest_id"].stringValue
        city = json["city"].stringValue
        country = json["country"].stringValue
        rooms = json["rooms"].arrayValue.map{RoomPassengerData($0)}
        checkin = json["checkin"].stringValue
        destName = json["dest_name"].stringValue
        origin = json["origin"].stringValue
        totalLegs = json["totalLegs"].stringValue
        adult = json["adult"].stringValue
        infant = json["infant"].stringValue
        depart = json["depart"].stringValue
        destination = json["destination"].stringValue
        tripType = json["trip_type"].stringValue
        cabinclass = json["cabinclass"].stringValue.capitalized
        child = json["child"].stringValue
        returnDate = json["return"].stringValue
        departCity = json["origin_city"].stringValue
        arrivalCity = json["destination_city"].stringValue
        productType = ProductType.getTypeFrom(self.product)
        settingFor = isFor
        switch productType{
        case .flight:
            self.returnDate = self.returnDate.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd-MM-yyyy") ?? self.returnDate
            self.depart = self.depart.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd-MM-yyyy") ?? self.depart
        case .hotel: break;
        case .other: break;
            
            
        }
        if ((Int(adult) ?? 0) == 0 && (Int(child) ?? 0) == 0){
            self.adult = "2"
        }
    }

}

struct RoomPassengerData{
    
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

struct AppleWalletFlight{
    var bookingId:String
    var name:String
    var flightId:String
    var isAdded:Bool = false
    
    init(bookingId: String, flight: BookingFlightDetail) {
        self.bookingId = bookingId
        self.name = "\(flight.departure) → \(flight.arrival)"
        self.flightId = flight.flightId
    }
}
